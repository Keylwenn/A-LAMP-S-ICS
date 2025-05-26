#!/bin/bash
#
#
# Script Information
#
# Script Name:          Automated LAMP Server Installation & Configuration Script
# Creation Date:        05/26/2025
# Version:              1.1
# License:              CC BY-NC-SA 4.0 (Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International) https://creativecommons.org/licenses/by-nc-sa/4.0/
#
# Author Information and Contributions
#
# Original Author:      Keylwenn, IT Student, France
# Email:                keylwenn@outlook.com
# Github:               https://github.com/Keylwenn
# Contributors:         Name, Role, Country - Information about the contributor, if any.
#                       Keylwenn, IT Student, FRANCE - https://github.com/Keylwenn, Email: keylwenn@outlook.com
#
# Description:
#                       This script is intended to be used by lazy people who want to quickly set up a LAMP server without having to manually enter each command in the terminal.
#                       This script is not intended to be used in production environments, but rather to facilitate the setup of a test environment.
#                       This script is not intended to be used as a substitute for system administration knowledge, but rather to facilitate the setup of a test environment.
#                       This script is originaly intended for educational purposes, specifically for students of the TSSR 2025 class at OFIAQ (TRAINING ORGANIZATION FOR INTEGRATION, SUPPORT, AND QUALIFICATION).
#                       This script should not be used as a substitute for system administration knowledge but rather to facilitate the setup of a test environment.
#                       This Script automatically install and configures a LAMP server (Linux, Apache, MySQL/MariaDB, PHP) on a Debian-based distribution.
#                       It is important to note that this script is intended for use in a test environment. It should not be used in production without prior testing.
#                       It is recommended to back up your system before running this script, as it may modify important configuration files.
#                       It is advisable to read the script code before executing it to understand its functionality.
#
#
# Variable definitions
# Package list definition
PACKAGES="openssh-server vsftpd apache2 mariadb-server php libapache2-mod-php php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip"
# Functions definitions
# Check the shell being used
check_shell() {
    if [[ "$SHELL" != "/bin/bash" ]]; then
        echo "This script is intended to be run with Bash shell. Please switch to Bash and try again."
        # Press enter to continue or switch to Bash
        echo -e "\e[1;31mPress Enter to switch to Bash shell or exit by pressing Ctrl+C\e[0m"
        # Wait for user input
        read -p "Press Enter to switch to Bash shell..." -n1 -s
        # Enter the command to switch to Bash
        exec /bin/bash "$0" "$@"
    else
        # Display a message indicating that the script is run with Bash shell
        echo -e "\e[1;32mBash shell detected. Proceeding with the script execution.\e[0m"
    fi
}
# Check if the script is run as root
check_root_user() {
    if [[ $EUID -ne 0 ]]; then
        # If not run as root, display an error message.
        echo -e "\e[1;34mThis script must be run as root. Please use 'sudo' or switch to the root user.\e[0m"
        # Press enter to get root or exit
        echo -e "\e[1;31mPress Enter to switch to root user or exit by pressing Ctrl+C\e[0m"
        # Wait for user input
        read -p "Press Enter to switch to root user..." -n1 -s
        # Enter the command to switch to root
        exec sudo STEP_AFTER_ROOT=1 bash "$0" "$@"
    else
        # Display a message indicating that the script is run as root
        echo -e "\e[1;32mRoot user detected. Proceeding with the script execution.\e[0m"
        read -p "Press Enter to execute the script..." -n1 -s
    fi
}
# Check system environment (Debian-based distribution)
check_system_environment() {
    if [[ -f /etc/debian_version ]]; then
        echo -e "\e[1;32mRoot user detected. Proceeding with the script execution.\e[0m"
        read -p "Press Enter to execute the script..." -n1 -s
        # Display a message indicating that a Debian-based distribution is detected
        echo -e "\e[1;32mDebian-based distribution detected. Proceeding with the script execution.\e[0m"
    else
        # If not a Debian-based distribution, display an error message and exit
        echo -e "\e[1;31mThis script is intended for Debian-based distributions only.\e[0m"
        # Press enter to exit
        echo -e "\e[1;31mPress Enter to exit the script.\e[0m"
        # Wait for user input
        read -p "Press Enter to exit..." -n1 -s
        # Exit the script
        echo -e "\e[1;31mExiting the script.\e[0m"
        # Exit with a non-zero status to indicate an error
        echo -e "\e[1;31mPlease run this script on a Debian-based system.\e[0m"
    fi
}
# Check user aknowledgment
check_user_acknowledgment() {
    echo -e "\e[1;34mTerms of use:\e[0m"
    echo -e "\e[1;34mIt is important to note that this script is intended for use in a test environment. It should not be used in production without prior testing.\e[0m"
    echo -e "\e[1;34mIt is recommended to back up your system before running this script, as it may modify important configuration files.\e[0m"
    echo -e "\e[1;34mIt is advisable to read the script code before executing it to understand its functionality.\e[0m"
    echo -e "\e[1;34mThis script is provided as-is, without warranty of any kind.\e[0m"
    echo -e "\e[1;31mAuthor is not responsible for any damage caused by the use of this script.\e[0m"
    echo -e "\e[1;31mBy proceeding with this script, you acknowledge that you have read and understood the above information.\e[0m"
}
# Function to prompt the user for acknowledgment
user_answer() {
    # Prompt the user for acknowledgment
    read -p "Do you agree to proceed? (yes/no): " response
    if [[ "$response" == "yes" ]]; then
        echo -e "\e[1;34mThank you for using this script.\e[0m"
        elif [[ "$response" == "no" ]]; then
        echo -e "\e[1;31mYou have to agree to the terms of use.\e[0m"
        # Exit the script if the user does not agree
        echo -e "\e[1;31mExiting the script.\e[0m"
        exit 0
    else
        # If the user enters an invalid response, prompt again
        echo -e "\e[1;31mInvalid answer, please enter \"yes\" or \"no\".\e[0m"
        user_answer
    fi
}
# Checks for package updates
check_update() {
    echo "Updating packages..."
    apt update && apt upgrade -y
    if [ $? -ne 0 ]; then
        echo "Failed to update packages."
        exit 1
    fi
}
# Checks for required packages and installs them if needed
install_packages() {
    echo "Installing required packages..."
    for package in $PACKAGES; do
        if ! dpkg -l | grep -q "^ii  $package "; then
            apt install -y $package
            if [ $? -ne 0 ]; then
                echo "Failed to install package $package."
                exit 1
            fi
        else
            echo "Package $package is already installed."
        fi
    done
}
# Function to secure MariaDB installation
secure_mariadb_installation() {
    echo "Securing MariaDB installation..."
    mysql_secure_installation <<EOF
Y
Y
P@ssw0rd
P@ssw0rd
Y
Y
Y
EOF
    if [ $? -ne 0 ]; then
        echo "Failed to secure MariaDB installation."
        exit 1
    fi
}
# Function to configure services
configure_services() {
    echo "Configuring services..."
    # SSH configuration
    sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/#ChallengeResponseAuthentication no/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
    sed -i 's/#UsePAM yes/UsePAM yes/' /etc/ssh/sshd_config
    sed -i 's/#X11Forwarding no/X11Forwarding yes/' /etc/ssh/sshd_config
    systemctl restart sshd
    # FTP configuration
    sed -i 's/#write_enable=YES/write_enable=YES/' /etc/vsftpd.conf
    systemctl restart vsftpd
    if [ $? -ne 0 ]; then
        echo "Failed to configure FTP services."
        exit 1
    fi
    # Apache configuration
    a2enmod rewrite
    systemctl restart apache2
    if [ $? -ne 0 ]; then
        echo "Failed to configure Apache."
        exit 1
    fi
    # MariaDB configuration
    systemctl restart mariadb
    if [ $? -ne 0 ]; then
        echo "Failed to configure MariaDB services."
        exit 1
    fi
}
# Message to display at the end of the script
end_message() {
    #echo -e "\e[1;32mScript execution completed successfully.\e[0m"
    #echo -e "\e[1;34mThank you for using this script!\e[0m"
    #exit 1
    echo -e "\e[1;34mConfiguration completed successfully!\e[0m"
    echo -e "\e[1;34mThe following services are configured:\e[0m"
    echo -e "\e[1;34m- SSH (port 2222)\e[0m"
    echo -e "\e[1;34m- FTP (vsftpd)\e[0m"
    echo -e "\e[1;34m- Apache\e[0m"
    echo -e "\e[1;34m- MariaDB\e[0m"
    echo -e "\e[1;34mCurrent date and time: $(date)\e[0m"
    echo -e "\e[1;34mYou can now use your LAMP server.\e[0m"
    echo -e "\e[1;34mIf you have any questions, please contact the author of this script...\e[0m"
    echo -e "\e[1;34mKeylwenn, IT Student, FRANCE - https://github.com/Keylwenn, Discord: X (Twitter): @Keylwenn, Email: keylwenn@outlook.com\e[0m"
    echo -e "\e[1;34mThank you for using this script!\e[0m"
    # Press Enter to exit
    echo -e "\e[1;32m\e[1mPress Enter to exit...\e[0m"
    read -r
    exit 0
}
# Main function to execute the script
main() {
    # Check the shell being used
    check_shell
    # Check if the script is run as root
    check_root_user
    # Check if the system is debian-based
    check_system_environment
    # Prompt user answer
    user_answer
    # Check user acknowledgment
    check_user_acknowledgment
    # Test function for the script
    #test_function
    # Check for Repository updates
    check_update
    # Install required packages
    install_packages
    # Secure MariaDB installation
    secure_mariadb_installation
    # Configure services
    configure_services
    # Display end message
    end_message
    # End message
    end_message
}
# After obtaining root privileges, check if the script should continue at a specific step
if [[ "$STEP_AFTER_ROOT" == "1" ]]; then
    # Check if the system is debian-based
    check_system_environment
    # Prompt user answer
    user_answer
    # Check user acknowledgment
    check_user_acknowledgment
    # Test function for the script
    #test_function
    # Check for Repository updates
    check_update
    # Install required packages
    install_packages
    # Secure MariaDB installation
    backup_config_files
    # Configure services
    configure_services
    # Display end message
    end_message
    # End message
    end_message
fi
# Script Execution
main
