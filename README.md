---

# The Automated LAMP Server Installation & Configuration Script

---

## License

This script is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/).

---

## Disclaimer

This script is provided as-is, without warranty of any kind.  
Use at your own risk.

---

## Author & Contributors

- **Original Author:** Keylwenn, IT Student, France  
  - [GitHub](https://github.com/Keylwenn)  
  - Email: keylwenn@outlook.com

- **Contributors:**  
  - Keylwenn, IT Student, France - https://github.com/Keylwenn, keylwenn@outlook.com

---

## Important Notes

- **Not for production:**  
  This script is intended for test and educational environments only.  
  Do not use in production without reviewing and adapting the script.

- **Back up your system:**  
  The script modifies important configuration files.  
  Always back up your system before running.

- **Review the code:**  
  Read the script before executing to understand its actions.

- **Author is not responsible for any damage caused by the use of this script.**

---

## Overview

**ALAMPSIC.sh** is a Bash script designed to automate the installation and configuration of a LAMP server (Linux, Apache, MariaDB/MySQL, PHP) on Debian-based distributions.  
It is primarily intended for educational and testing purposes, especially for students of the TSSR 2025 class at OFIAQ (Training Organization for Integration, Support, and Qualification).

---

## Features

- Installs and configures:
  - Apache2
  - MariaDB server
  - PHP and common extensions
  - OpenSSH server
  - vsftpd FTP server
- Backs up and modifies key configuration files
- Secures MariaDB installation
- Enables Apache rewrite module
- Changes SSH port and enables root login (for test environments)
- Designed for quick, repeatable LAMP stack setup in test environments

---

## Usage

1. **Download the script**  
   Place `ALAMPSIC.sh` on your Debian-based system.

2. **Make the script executable**  
   ```bash
   chmod +x ALAMPSIC.sh
   ```

3. **Run the script as root**  
   ```bash
   sudo ./ALAMPSIC.sh
   ```

4. **Follow the on-screen instructions**  
   - Read and accept the terms of use.
   - The script will proceed with installation and configuration.

---

## Important Notes

- **Not for production:**  
  This script is intended for test and educational environments only.  
  Do not use in production without reviewing and adapting the script.

- **Back up your system:**  
  The script modifies important configuration files.  
  Always back up your system before running.

- **Review the code:**  
  Read the script before executing to understand its actions.

- **Author is not responsible for any damage caused by the use of this script.**

---
