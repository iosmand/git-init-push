# git-init-push

## Description

This is a bash script that simplifies the process of initializing a Git repository, committing changes, and pushing them to a remote repository.

## Installation

To install the script, run the following command in your terminal:

    curl -o git-init-push.sh https://raw.githubusercontent.com/iosmand/git-init-push/main/git-init-push.sh && chmod +x git-init-push.sh && sudo cp git-init-push.sh /usr/local/bin/git-init-push && rm git-init-push.sh

## Usage

The script can be used with the following command line arguments:

    git-init-push -u [username] -r [repository_name] ( -t [access_token] | -k [deploy_key.pub] )

### Options:

- `-u [username]`: Specifies the username for the remote repository.
- `-r [repository_name]`: Specifies the name of the repository.
- `-t [access_token]`: Specifies the access token to authenticate with the remote repository.
- `-k [deploy_key.pub]`: Specifies the path to the deploy key file for authentication.
- `-s [github]`: Specifies the Git service (default: github).
- `-d [destination_folder]`: Specifies the destination folder for the Git repository (default: current directory).

### Examples:

Initialize a Git repository, commit changes, and push to a GitHub repository using an access token:

    git-init-push -u your_username -r your_repository -t your_access_token

Initialize a Git repository, commit changes, and push to a GitHub repository using a deploy key:

    git-init-push -u your_username -r your_repository -k path/to/deploy_key.pub

Initialize a Git repository, commit changes, and push to a Bitbucket repository:

    git-init-push -u your_username -r your_repository -t your_access_token -s bitbucket

Initialize a Git repository, commit changes, and push to a GitLab repository:

    git-init-push -u your_username -r your_repository -k path/to/deploy_key.pub -s gitlab

## License

This script is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html). See the [LICENSE](LICENSE) file for more details.
