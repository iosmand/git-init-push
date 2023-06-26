Git Init Push Script
====================

This Bash script enables a Git repository to push to GitHub by automating the initialization, file addition, commit, and remote configuration steps.

Usage
-----

### Running the script directly:

    ./git-init-push.sh [username] [access_token] [repository_url]

If no arguments are provided, the script will prompt for the required information interactively. Make sure to provide the execute permission to the script using `chmod +x git-init-push.sh`.

### Running as a Native Linux Command:
-------------------------------

Give the script execute permissions and save the script in a directory listed in your system's `PATH` environment variable, such as `/usr/local/bin` or `~/bin` by running command `sudo chmod +x git-init-push.sh && sudo cp git-init-push.sh /usr/local/bin/git-init-push`.

After copying it, you can use the command `git-init-push` from anywhere in the terminal to execute the script.

    git-init-push [username] [access_token] [repository_url]

If no arguments are provided, the script will prompt for the required information interactively.

Examples
--------

### Run the script directly:

    ./git-init-push.sh your_username your_access_token https://github.com/your_username/repo.git

### Run the script as a native Linux command:

    git-init-push your_username your_access_token https://github.com/your_username/repo.git

In both cases, replace `your_username` with your actual GitHub username, `your_access_token` with your GitHub access token, and `https://github.com/your_username/repo.git` with the appropriate repository URL.

Requirements
------------

*   **Bash:** You can install Bash using the package manager for your Linux distribution. For example, on Ubuntu, use the command:  
    `sudo apt-get install bash`
*   **Git:** Install Git using your package manager. For example, on Ubuntu, use:  
    `sudo apt-get install git`

License
-------

This script is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html). See the [LICENSE](LICENSE) file for more details.
