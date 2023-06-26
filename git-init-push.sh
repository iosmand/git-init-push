#!/bin/bash

# Help message and usage examples
help_message="
Usage: enable_git_push.sh

This script enables a Git repository to push to GitHub by performing the following steps:
  1. Initialize a new Git repository
  2. Add files to the repository
  3. Commit the changes
  4. Add the remote repository URL
  5. Push the local repository to GitHub

Usage examples:
  - Run the script and provide all inputs interactively:
    ./enable_git_push.sh

  - Run the script and provide the GitHub username, access token, and repository URL as arguments:
    ./enable_git_push.sh <username> <access_token> <repository_url>
"

# Check if help flag is provided
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  echo "$help_message"
  exit 0
fi

# Prompt the user for their GitHub username
if [[ -z "$1" ]]; then
  read -p "Enter your GitHub username: " username
else
  username="$1"
fi

# Prompt the user for their GitHub access token
if [[ -z "$2" ]]; then
  read -s -p "Enter your GitHub access token: " access_token
  echo
else
  access_token="$2"
fi

# Prompt the user for the repository URL
if [[ -z "$3" ]]; then
  read -p "Enter the GitHub repository URL: " repository_url
else
  repository_url="$3"
fi

# Initialize Git repository
git init

# Add files to the repository
git add .

# Commit the changes
read -p "Enter the commit message: " commit_message
git commit -m "$commit_message"

# Add the remote repository URL
git remote add origin "$repository_url"

# Verify the remote repository
git remote -v

# Push the local repository to GitHub using the access token
git push -u "$username":"$access_token" master
