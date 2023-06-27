# git-init-push

## Description

This script initializes a Git repository, makes an initial commit, and pushes it to a remote repository. It provides options to set up the repository with a specific username, repository name, and authentication method (access token or deploy key).

## Installation

To use this script, you can execute the following command:

    curl -o git-init-push.sh https://raw.githubusercontent.com/iosmand/git-init-push/main/git-init-push.sh && chmod +x git-init-push.sh && sudo cp git-init-push.sh /usr/local/bin/git-init-push && rm git-init-push.sh

The command downloads the script, makes it executable, copies it to the `/usr/local/bin` directory (requires sudo access), and removes the downloaded script.

## Usage

Once installed, you can run the script by typing `git-init-push` in the terminal, followed by the necessary options.

### Options

- `-u [username]`: Specifies the username for the remote repository.
- `-r [repository_name]`: Specifies the name of the remote repository.
- `-t [access_token]`: Specifies the access token for authentication.
- `-k [deploy_key.pub]`: Specifies the path to the deploy key public key file.
- `-s [github]`: Specifies the Git service (currently only supports GitHub).
- `-d [destination_folder]`: Specifies the destination folder for the Git repository (default: current directory).

### Examples

Initialize and push a repository with an access token:

    git-init-push -u your_username -r your_repository -t YOUR_ACCESS_TOKEN

Initialize and push a repository with a deploy key:

    git-init-push -u your_username -r your-repository -k PATH/TO/deploy_key.pub

## License

This script is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html). See the [LICENSE](LICENSE) file for more details.
