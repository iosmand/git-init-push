#!/bin/bash

# Git Init Push Script
# This Bash script enables a Git repository to push to GitHub by automating the initialization, file addition, commit, and remote configuration steps.

# Check if the script has execute permission
if [ ! -x "$0" ]; then
  echo "Please make sure the script has execute permission."
  exit 1
fi

# Check if Git is installed
if ! command -v git &> /dev/null; then
  echo "Git is not installed. Please install it first."
  exit 1
fi

# Check if the user requested help
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo -e "Usage: $0 [username] [access_token] [repository_url]\n\nThis Bash script enables a Git repository to push to GitHub by automating the initialization, file addition, commit, and remote configuration steps.\n\nIf no arguments are provided, the script will prompt for the required information interactively.\n\nExamples:\n./$0 your_username your_access_token https://github.com/your_username/repo.git\n$0 your_username your_access_token https://github.com/your_username/repo.git"
  exit 0
fi

# Get the username, access token and repository URL from arguments or prompt
username=${1:-$(read -p "Enter your GitHub username: " input && echo $input)}
access_token=${2:-$(read -p "Enter your GitHub access token: " input && echo $input)}
repository_url=${3:-$(read -p "Enter your GitHub repository URL: " input && echo $input)}

# Validate the inputs
if [ -z "$username" ] || [ -z "$access_token" ] || [ -z "$repository_url" ]; then
  echo "Invalid inputs. Please provide valid username, access token and repository URL."
  exit 1
fi

# Initialize the repository
git init

# Add all files to the staging area
git add .

# Commit with a default message
git commit -m "Initial commit"

# Set the remote origin using the username, access token and repository URL
git remote add origin https://$username:$access_token@$repository_url

# Push to the remote origin
git push -u origin master

# Print a success message
echo "Successfully pushed to GitHub!"
