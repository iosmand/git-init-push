#!/bin/bash

# Usage: git-init-push -u [username] -r [repository_name] ( -t [access_token] | -k [deploy_key.pub] )
# Optional entries: -s [github] -d [destination_folder]

# Parse the command line arguments
while getopts u:r:t:k:s:d: option
do
case "${option}"
in
u) USER=${OPTARG};;
r) REPO=${OPTARG};;
t) TOKEN=${OPTARG};;
k) KEY=${OPTARG};;
s) SERVICE=${OPTARG};;
d) DEST=${OPTARG};;
esac
done

# Check if the user and repo arguments are provided
if [[ -z $USER || -z $REPO ]]; then
  echo "Usage: git-init-push -u [username] -r [repository_name] ( -t [access_token] | -k [deploy_key.pub] )"
  echo "Optional entries: -s [github] -d [destination_folder]"
  exit 1
fi

# Check if the token or key argument is provided and only one of them
if [[ -z $TOKEN && -z $KEY ]]; then
  echo "You must provide either an access token or a deploy key"
  exit 1
elif [[ -n $TOKEN && -n $KEY ]]; then
  echo "You can only provide either an access token or a deploy key, not both"
  exit 1
fi

# Set the default service to github if not provided
if [[ -z $SERVICE ]]; then
  SERVICE="github"
fi

# Set the default destination folder to the current directory if not provided
if [[ -z $DEST ]]; then
  DEST="."
fi

# Define a function to create a remote url based on the service and credentials
create_remote_url () {
  local service=$1
  local user=$2
  local token=$3
  local key=$4
  local repo=$5
  local remote_url=""
  if [[ $service == "github" ]]; then
    if [[ -n $token ]]; then
      remote_url="https://${token}@${user}@${service}.com/${user}/${repo}.git"
    elif [[ -n $key ]]; then
      remote_url="git@${service}.com:${user}/${repo}.git"
    fi
  elif [[ $service == "bitbucket" ]]; then
    if [[ -n $token ]]; then
      remote_url="https://${user}:${token}@${service}.org/${user}/${repo}.git"
    elif [[ -n $key ]]; then
      remote_url="git@${service}.org:${user}/${repo}.git"
    fi
  elif [[ $service == "gitlab" ]]; then
    if [[ -n $token ]]; then
      remote_url="https://${user}:${token}@${service}.com/${user}/${repo}.git"
    elif [[ -n $key ]]; then
      remote_url="git@${service}.com:${user}/${repo}.git"
    fi  
  else
    echo "Unknown git service: ${service}"
    exit 1  
  fi  
  echo $remote_url  
}

# Define a function to create a deploy key and display it on the screen
create_deploy_key () {
  local key=$1  
  ssh-keygen -t rsa -b 4096 -C "${USER}@${SERVICE}.com" -f $key -N ""
  echo "This is your deploy key. Copy and paste it to your git service."
  cat $key.pub  
}

# Define a function to initialize, commit and push a git repo 
init_commit_push () {
  local dest=$1  
  local remote_url=$2  
  cd $dest  
  if [ ! -d ".git" ]; then # Check if git is not initialized in the destination directory  
    git init # Initialize the git repo  
    git add . # Add all files to the staging area  
    git commit -m "Initial commit" # Commit the changes with a message  
    git remote add origin $remote_url # Add the remote url as origin  
    git push origin master # Push the changes to the master branch of the remote repo  
  else # Check if git is already initialized in the destination directory  
    git add . # Add all files to the staging area  
    git commit -m "Update" # Commit the changes with a message  
    git push origin master # Push the changes to the master branch of the remote repo  
  fi  
}

# Main logic of the script
if [[ -n $KEY ]]; then # Check if the key argument is provided  
  create_deploy_key $KEY # Create a deploy key and display it on the screen  
  read -p "Press any key to continue..." # Wait for a key press from the user  
fi

remote_url=$(create_remote_url $SERVICE $USER $TOKEN $KEY $REPO) # Create a remote url based on the service and credentials
init_commit_push $DEST $remote_url # Initialize, commit and push a git repo
