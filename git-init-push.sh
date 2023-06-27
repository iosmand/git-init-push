#!/bin/bash

SCRIPT_NAME="git-init-push.sh"
REQUIRED_PACKAGES=("git" "ssh-keygen")

# Function to check if necessary options are provided
check_options() {
    username=""
    repository_name=""
    access_token=""
    deploy_key=""
    service="github"
    destination_folder="."

    # Parse command line arguments
    while getopts ":u:r:t:k:s:d:" opt; do
        case $opt in
            u) username="$OPTARG" ;;
            r) repository_name="$OPTARG" ;;
            t) access_token="$OPTARG" ;;
            k) deploy_key="$OPTARG" ;;
            s) service="$OPTARG" ;;
            d) destination_folder="$OPTARG" ;;
            \?) echo "Invalid option -$OPTARG. Aborting."; exit 1 ;;
        esac
    done

    # Check if username and repository_name are provided
    if [[ -z $username || -z $repository_name ]]; then
        echo "Error: Please provide a username (-u) and repository name (-r). Aborting."
        exit 1
    fi

    # Check if access_token or deploy_key is provided
    if [[ -z $access_token && -z $deploy_key ]]; then
        echo "Error: Please provide either an access token (-t) or a deploy key (-k). Aborting."
        exit 1
    fi

    # Check if only one of access_token or deploy_key is provided
    if [[ -n $access_token && -n $deploy_key ]]; then
        echo "Error: Please provide only one of either an access token (-t) or a deploy key (-k). Aborting."
        exit 1
    fi

    # Handle deploy_key option
    if [[ -n $deploy_key ]]; then
        if [[ $deploy_key == "create" ]]; then
            echo "Creating deploy_key.pub..."
            ssh-keygen -t rsa -b 4096 -N "" -f deploy_key || { echo "Failed to create deploy_key.pub. Aborting."; exit 1; }
            cat deploy_key.pub
            echo "Press any key to continue..."
            read -r
            deploy_key="deploy_key.pub"
        elif [[ ! -f $deploy_key ]]; then
            echo "Deploy key file not found: $deploy_key. Aborting."
            exit 1
        fi
    fi

}

# Function to check if dependent packages are installed and install if necessary
check_dependencies() {
    local missing_packages=()
    for package in "${REQUIRED_PACKAGES[@]}"; do
        if ! command -v "$package" >/dev/null 2>&1; then
            missing_packages+=("$package")
        fi
    done

    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        echo "Installing missing packages: ${missing_packages[*]}..."
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update && sudo apt-get install -y "${missing_packages[@]}" || { echo "Failed to install packages. Aborting."; exit 1; }
        else
            echo "Error: Package manager not found. Please install the required packages manually: ${missing_packages[*]}"
            exit 1
        fi
    fi
}

# Function to initialize git repository, commit, and push
git_init_push() {
    local username=$1
    local repository_name=$2
    local access_token=$3
    local deploy_key=$4
    local service=$5
    local destination_folder=$6

    # Check if git is already initialized in the destination directory
    if [[ ! -d $destination_folder/.git ]]; then
        # Initialize git repository
        echo "Initializing git repository..."
        git init "$destination_folder" || { echo "Failed to initialize git repository. Aborting."; exit 1; }
    fi

    # Configure git remote URL based on the service
    case $service in
        github) remote_url="git@github.com:$username/$repository_name.git" ;;
        gitlab) remote_url="git@gitlab.com:$username/$repository_name.git" ;;
        bitbucket) remote_url="git@bitbucket.org:$username/$repository_name.git" ;;
        *) echo "Error: Unknown git service. Aborting."; exit 1 ;;
    esac

    # Add remote origin
    git -C "$destination_folder" remote add origin "$remote_url" || { echo "Failed to add remote origin. Aborting."; exit 1; }

    # Set deploy key or access token
    if [[ -n $deploy_key ]]; then
        # Set deploy key
        echo "Setting deploy key..."
        git -C "$destination_folder" config core.sshCommand "ssh -i $deploy_key"
    elif [[ -n $access_token ]]; then
        # Set access token
        echo "Setting access token..."
        git -C "$destination_folder" config http.extraheader "Authorization: Bearer $access_token"
    fi

    # Commit all files
    git -C "$destination_folder" add . || { echo "Failed to add files to commit. Aborting."; exit 1; }
    git -C "$destination_folder" commit -m "Initial commit" || { echo "Failed to commit files. Aborting."; exit 1; }

    # Push to remote repository
    git -C "$destination_folder" push -u origin master || { echo "Failed to push to remote repository. Aborting."; exit 1; }

    echo "Git repository initialized, committed, and pushed successfully!"
}

# Main script logic

# Check if the script is executable
check_executable

# Check if necessary options are provided
check_options "$@"

# Check and install dependencies if necessary
check_dependencies

# Call git_init_push function
git_init_push "$username" "$repository_name" "$access_token" "$deploy_key" "$service" "$destination_folder"
