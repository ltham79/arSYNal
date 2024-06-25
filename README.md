<div align="center">
  
# arSYNal

![GitHub repo size](https://img.shields.io/github/repo-size/ltham79/arsynal)
![GitHub contributors](https://img.shields.io/github/contributors/ltham79/arsynal)
![GitHub stars](https://img.shields.io/github/stars/ltham79/arsynal?style=social)
![GitHub forks](https://img.shields.io/github/forks/ltham79/arsynal?style=social)
</br>
<img src="https://komarev.com/ghpvc/?username=your-github-username&style=flat-square&color=blue" alt=""/>

<a href="https://www.buymeacoffee.com/psiber_syn" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>

</div>

## Description

**arSYNal** is a comprehensive Bash script designed as a walk-through for numerous cybersecurity tools available in the default Kali Linux installation. It assists both professionals and amateurs in conducting various penetration testing and security analysis tasks by guiding users through the options for each tool. 

## Features

- **Graphical Menu**: ASCII art graphical menu navigated using arrow keys.
- **Tool Integration**: Supports tools such as `nmap` (various `nmap` scans including NSE scripts for XSS, LFI, and SQL vulnerabilities.), `searchsploit`, `sqlmap`, `dnsrecon`, `dig`, `dnsenum`, `hydra`, `medusa`, `john the ripper`, `fping`, `nikto`, `hashcat`, `cewl`, `dotdotpwn`, `theharvester`, `dnsmap`, `gobuster`, `dirb`, `wpscan`, `wfuzz`, `ffuf`, and hash identifier.
- **Command Log**: Logs all executed commands for review and auditing.
- **Result Saving**: Ability to save scan results and view them later.
- **User Script Support**: Allows users to add custom scripts and integrate them into the menu simply by dropping them in the scripts directory and arSYNal will populate the menu for you.
- **Cheatsheet Collection**: Extensive collection of cheatsheets for various tools can add your own .tx or .pdf cheatsheets by adding them to the cheatsheets directory and arSYNal will populate the menu for you.
- **Fun Zone**: Includes fun animations and activities to keep users engaged.
- **Paginated Display**: Paginate saved results and cheatsheets in an ASCII graphical frame.
- **Network Utilities**: Easily manage `/etc/hosts` file, perform GeoIP lookups, and run a condensed output of ifconfig

## Screenshots / GIFs

![Main Menu](#)
*Add a screenshot or GIF of the main menu here.*

![Tool Options](#)
*Add a screenshot or GIF showing the tool options here.*

## Installation

### Clone the Repository

```bash
git clone https://github.com/ltham79/arSYNal.git
cd arSYNal
chmod +x arSYNal.sh
```
##Usage

Execute the script:

```bash
./arsynal.sh
```

Follow the on-screen prompts to navigate through the various tool options, save results, and enjoy the fun zone activities.

Contributing
Contributions are welcome! Please feel free to submit issues and pull requests.

License
This project is licensed under the MIT License - see the LICENSE file for details.
