<div align="center">
  <img src="https://github.com/ltham79/arSYNal/assets/139496887/b7a6d84c-db89-4b19-b280-6d6a51acd6de" width="85%" height="85%">

# arSYNal

![GitHub repo size](https://img.shields.io/github/repo-size/ltham79/arSYNal)
![GitHub contributors](https://img.shields.io/github/contributors/ltham79/arSYNal)
![GitHub stars](https://img.shields.io/github/stars/ltham79/arSYNal?style=social)
![GitHub forks](https://img.shields.io/github/forks/ltham79/arSYNal?style=social)
</br>
<img src="https://komarev.com/ghpvc/?username=ltham79&style=flat-square&color=blue" alt=""/>

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
- **Cheatsheet Collection**: Extensive collection of cheatsheets for various tools can add your own .txt or .pdf cheatsheets by adding them to the cheatsheets directory and arSYNal will populate the menu for you.
- **Fun Zone**: Includes fun animations and activities to keep users engaged.
- **Paginated Display**: Paginate saved results and cheatsheets in an ASCII graphical frame.
- **Network Utilities**: Easily manage `/etc/hosts` file, perform GeoIP lookups, and run a condensed output of ifconfig


## Main Menu
<img src="https://github.com/ltham79/arSYNal/assets/139496887/0f2d083b-d17f-418d-8f18-4fa0c8a193c0" width="55%" height="auto">


## Action
<img src="https://github.com/ltham79/arSYNal/assets/139496887/e49ebc60-80ec-49b5-9c43-f2ee84f50d01" width="55%" height="auto%">

## Cheatsheets 
<img src="https://github.com/ltham79/arSYNal/assets/139496887/97d67278-754d-4a23-92b9-35fd4ce9a62c" width="55%" height="auto">

## Installation

### Clone the Repository

```bash
git clone https://github.com/ltham79/arSYNal.git
cd arSYNal
chmod +x arSYNal.sh
```
## Usage

Execute the script:

```bash
./arSYNal.sh
# or
./arSYNal.sh --noshow
# to not show the banner
```

## Dependancies

Use the install tools menu option to make surw all of the tools required to function properly are installed.


Follow the on-screen prompts to navigate through the various tool options, save results, and enjoy the fun zone activities.

## Issues
This is only my second project with bash scripting so it probably is not the best looking script or the best way to complete some tasks but I got everything to work the only way I could figure out. So please be gentle with the criticism.

Also the only major issues are that I can not get the screen flicker to stop when navigating the menu. If anyone can help I would be gladly appreciative. And sometimes it does not show the results the first time. If this happens save the results and then open them from the saved results menu option.

If any other issues are found please let me know.

Thank you
Psiber_Syn

## Contributing
Contributions are welcome! Please feel free to submit issues and pull requests.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
