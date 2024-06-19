Overview
This script is a comprehensive toolkit that offers various network and security functionalities. It is designed to assist with port scanning, vulnerability scanning, password cracking, network analysis, and more. Additionally, it includes fun and informative features such as ASCII art and cheatsheets. The script also logs actions performed, which can be reviewed in reverse chronological order.

Features
Port Scanning:

Ping Sweep
Nmap Scans
Enumeration (DNS, File System, Web)
Vulnerability Scanning:

Nikto Scan
SQLmap
WPScan
Password Cracking:

John the Ripper
Hashcat
Hydra
Medusa
CeWL
Hash-ID
Network Tools:

ifconfig
Hosts file
geoIP
Fun Zone:

Joker Bomb
Matrix
Clock
Tetris
Weather Man
ASCII STAR WARS
User Scripts: Load and execute custom scripts from the scripts directory.

Cheatsheets: Access and view various cheatsheets stored in the cheatsheets directory.

Command Logging: Logs all executed commands with timestamps and dates. Logs can be reviewed starting with the most recent entries.

Setup
Clone the repository:

bash
Copy code
git clone https://github.com/yourusername/your-repo.git
cd your-repo
Make the script executable:

bash
Copy code
chmod +x test.sh
Ensure the necessary directories (scripts, results, cheatsheets) exist in the same directory as the script:

bash
Copy code
mkdir -p scripts results cheatsheets
Usage
Run the script using the following command:

bash
Copy code
./test.sh
Main Menu Options
Scanners: Access various scanning tools including Nmap and enumeration tools.
Vulnerability Scanning: Use Nikto, SQLmap, and WPScan for vulnerability assessments.
Password Cracking: Utilize John the Ripper, Hashcat, and other password cracking tools.
Network Tools: Use basic network tools like ifconfig and geoIP.
User Scripts: Load and run custom user scripts.
Fun Zone: Enjoy fun scripts like Matrix, Tetris, and ASCII Star Wars.
Cheatsheets: View cheatsheets for quick references.
Saved Results: View saved results from previous scans and actions.
Exit: Exit the script.
Logging and Reviewing Actions
All actions are logged in execution_log.syn. To review the logs starting with the most recent entries:

Select Saved Results from the main menu.
Choose Command Logs.
This will display the command logs starting with the most recent date.

Customization
You can add your own scripts to the scripts directory. Ensure they are executable:

bash
Copy code
chmod +x scripts/your-script.sh
Add your cheatsheets to the cheatsheets directory for quick reference.

Troubleshooting
If you encounter any issues, ensure that:

The script has executable permissions.
Necessary directories (scripts, results, cheatsheets) exist.
Dependencies for various tools (e.g., Nmap, John the Ripper) are installed.
Contributing
Contributions are welcome! Please fork the repository and create a pull request with your changes. Ensure your code follows the existing style and structure.

License
This project is licensed under the MIT License. See the LICENSE file for details.


#!/bin/bash

# Update package lists
sudo apt-get update

# Install tools for Scanners
sudo apt-get install -y nmap pdftotext

# Install tools for Enumeration
sudo apt-get install -y dnsutils dnsrecon dnsenum dirb gobuster wfuzz

# Install tools for Vulnerability Scanning
sudo apt-get install -y nikto sqlmap wpscan

# Install tools for Password Cracking
sudo apt-get install -y john hashcat hydra medusa cewl

# Install any additional tools (if mentioned)
sudo apt-get install -y theharvester dotdotpwn

# Print completion message
echo "Installation of tools completed."
