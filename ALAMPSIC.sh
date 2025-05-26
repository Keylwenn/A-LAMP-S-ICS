#!/bin/bash
#
#
# Script Information
#
# Script Name:          Automated LAMP Server Installation & Configuration Script (ALAMPSIC.sh or ALAMPSIC)
# Creation Date:        05/26/2025
# Version:              1.0
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
#                       This Script automatically configures a LAMP server (Linux, Apache, MySQL/MariaDB, PHP) on a Debian-based distribution.
#                       It is important to note that this script is intended for use in a test environment. It should not be used in production without prior testing.
#                       It is recommended to back up your system before running this script, as it may modify important configuration files.
#                       It is advisable to read the script code before executing it to understand its functionality.


# Variable definitions
# Package list definition
PACKAGES="openssh-server vsftpd apache2 mariadb-server php libapache2-mod-php php-mysql php-cli php-curl php-gd php-mbstring php-xml php-zip"
# Configuration file paths definition
CONFIG_FILES=(²
    "/etc/ssh/sshd_config"
    "/etc/vsftpd.conf"
    "/etc/apache2/apache2.conf"
    "/etc/mysql/mariadb.conf.d/50-server.cnf"
)
# Backup file paths definition
BACKUP_FILES=(
    "/etc/ssh/sshd_config.bak"
    "/etc/vsftpd.conf.bak"
    "/etc/apache2/apache2.conf.bak"
    "/etc/mysql/mariadb.conf.d/50-server.cnf.bak"
)
# Backup file paths definition for second backup
BACKUP_FILES2=(
    "/etc/ssh/sshd_config.bak2"
    "/etc/vsftpd.conf.bak2"
    "/etc/apache2/apache2.conf.bak2"
    "/etc/mysql/mariadb.conf.d/50-server.cnf.bak2"
)

# Main function
main () {
    # Display current date and time
    echo "Current date and time: $(date)"
    # Display script start message
    echo "Starting Script: ALAMPSIC.sh execution"
    # Display terms of use
    echo "Terms of use:"
    echo "- By running this script, you accept the following terms of use:"
    echo "- This script is intended for use in a test environment."
    echo "- It should not be used in production without prior testing."
    echo "- It is recommended to back up your system before running this script, as it may modify important configuration files."
    echo "- It is recommended to read the script code before running it to understand what it does."
    echo "- The author of this script is not responsible for any damage caused by the use of this script."
    echo "- If you do not accept these terms, please exit the script by pressing Ctrl+C."
    echo "- If you do not accept these terms, please exit the script by pressing Ctrl+C."
    echo "- If you do not accept these terms, please exit the script by pressing Ctrl+C."
    echo "- If you accept these terms, press Enter to continue..."
    # Wait for Enter key press
    read -r
    # Check for bash presence
    check_bash
    # Check distribution
    check_distro
    # Check for root privileges
    check_root
    # Check for package updates
    check_update
    # Install required packages
    install_packages
    # Secure MariaDB installation
    secure_mariadb_installation
    # Backup configuration files
    backup_config_files
    # Configure services
    configure_services
    # Backup configuration files
    backup_config_files2
    # Display end message
    end_message
}

# Function declarations
# Check for bash presence
check_bash() {
    if [ -z "$BASH_VERSION" ]; then
        echo "This script must be run with bash."
        exit 1
    fi
}
# Checks that the script is running on a Debian or Debian-based distribution, otherwise exits!
check_distro() {
    if ! grep -qEi "(debian|ubuntu|kali|raspbian)" /etc/os-release; then
        echo "This script must be run on a Debian or Debian-based distribution."
        exit 1
    fi
}
# Checks if the script is run as root
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run as root. If you do not have root/sudo privileges, please contact the system administrator."
        exit 1
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
# Function to backup the default configuration files
backup_config_files() {
    for i in "${!CONFIG_FILES[@]}"; do
        if [ -f "${CONFIG_FILES[$i]}" ]; then
            cp "${CONFIG_FILES[$i]}" "${BACKUP_FILES[$i]}"
            if [ $? -ne 0 ]; then
                echo "Failed to backup ${CONFIG_FILES[$i]}."
                exit 1
            fi
        else
            echo "File ${CONFIG_FILES[$i]} does not exist, it will not be backed up."
        fi
    done
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
    if
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
# Function to backup the configuration files
backup_config_files2() {
    for i in "${!CONFIG_FILES[@]}"; do
        if [ -f "${CONFIG_FILES[$i]}" ]; then
            cp "${CONFIG_FILES[$i]}" "${BACKUP_FILES2[$i]}"
            if [ $? -ne 0 ]; then
                echo "Failed to backup ${CONFIG_FILES[$i]}."
                exit 1
            fi
        else
            echo "File ${CONFIG_FILES[$i]} does not exist, it will not be backed up."
        fi
    done
}
# Function to display an end message
end_message() {
    echo "Configuration completed successfully!"
    echo "The following services are configured:"
    echo "- SSH (port 2222)"
    echo "- FTP (vsftpd)"
    echo "- Apache"
    echo "- MariaDB"
    echo "Curent date and time: $(date)"
    echo "You can now use your LAMP server."
    echo "If you have any questions, please contact the author of this script..."
    echo "Keylwenn, IT Student, FRANCE - https://github.com/Keylwenn, Discord: X (Twitter): @Keylwenn, Email: keylwenn@outlook.com"
    echo "Thank you for using this script!"
    # Press Enter to exit
    echo "Press Enter to exit..."
    read -r
    exit 0
}
# Run the main function
main