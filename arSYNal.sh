#!/bin/bash
# shellcheck disable=SC2059,SC2162,SC2028,SC1001,SC1012,SC2269
# Define an array of options
main_options=("Scanners" "Vulnerability Scanning" "Password Cracking" "Network Tools" "User Scripts" "Fun Zone" "Cheatsheets" "Saved Results" "Exit")
###### Port scan menu
scanners_options=("Ping Sweep" "Nmap Scans" "Enumeration" "Back")
enum_scans_options=("DNS" "File System" "Web" "Back" "Main Menu")
enum_web_options=("GoBuster" "DirB" "FFuF" "wFuzz" "Back" "Main Menu")
enum_dns_options=("Dig" "DNSenum" "DNSrecon" "DNSmap" "theHarvester" "Back" "Main Menu")
enum_file_options=("DotDotPwn" "SearchSploit" "Back" "Main Menu")
nmap_scans_options=("Basic Scans" "Advanced Scans" "Scripted Scans" "Total Nmap Scan" "Back" "Main Menu")
###### Nmap Menu
basic_scan_submenu_options=("Basic Nmap Scan" "Service Version Detection" "Fast Nmap Scan" "TCP Nmap Scan" "TCP ACK Nmap Scan" "UDP Nmap Scan" "Active Host Network Nmap Scan" "Back" "Main Menu")
advanced_scan_submenu_options=("IP Protocol Nmap Scan" "Stealth Scan" "IP/Mac Spoofing Scan" "Aggressive Scan" "Back" "Main Menu")
scripting_scan_submenu_options=("HTTP site map Generator" "Nmap XSS Scan" "Nmap SQL Scan" "Back" "Main Menu")
###### Vulnerability scan menu
vuln_scanning_options=("Nikto Scan" "SQLmap" "WPScan" "Back")
###### Password cracking menu
password_cracking_options=("John the Ripper" "Hashcat" "Hydra" "Medusa" "CeWL" "Hash-ID" "Back")
###### Network menu
network_tools_options=("ifconfig" "Hosts file" "geoIP" "Back")
fun_zone_options=("Joker Bomb" "Matrix" "Clock" "Tetris" "Weather Man" "ASCII STAR WARS" "Install Tools" "Back")
tools=(nmap searchsploit sqlmap dnsrecon dig dnsenum hydra medusa john fping nikto hashcat cewl dotdotpwn theharvester dnsmap gobuster dirb wpscan wfuzz ffuf hash-identifier)

# Initialize variables
selected_index=0
info_box=""
current_menu="main"
menu_box="   Main Menu"
results=""
user_scripts_directory="scripts"
user_script_options=()
saved_results_directory="results"
saved_results_options=()
cheatsheets_directory="cheatsheets"
cheatsheets_options=()
previous_command=""
previous_datestamp=$(date +"%Y-%m-%d")

# Define an array of directories
DIRECTORIES=("hashes" "results")

# Loop through each directory in the array
for DIRECTORY in "${DIRECTORIES[@]}"; do
  # Create directory if it doesn't exist
  if [ ! -d "$DIRECTORY" ]; then
    mkdir "$DIRECTORY"
    
  fi

# Define ANSI color codes
RED='\e[31m'
ORANGE='\e[33m'
YELLOW='\e[1;33m'
GREEN='\e[32m'
BLUE='\e[34m'
INDIGO='\e[35m'
VIOLET='\e[35;1m'
CYAN='\e[0;36m'
FILL='\e[0;44;36m\e[1;36m'
NC='\e[0m' # No Color
END="${YELLOW}⣿${NC}${GREEN}⣶${NC}${BLUE}⣤${NC}${RED}⣀${NC}"
START="${RED}⣀${NC}${BLUE}⣤${NC}${GREEN}⣶${NC}${YELLOW}⣿${NC}"
TRIANGLE=$'\uE0B0'

# Function to log actions
log_action() {
    local log_file="execution_log.syn"
    local timestamp
    timestamp=$(date +"%H:%M:%S")
    local datestamp
    datestamp=$(date +"%Y-%m-%d")
    local action
    # Extract action from function name
    action=$(echo "${FUNCNAME[1]}" | sed 's/perform_//; s/_/ /g')
    local command="$1"

    local previous_datestamp=""
    if [ -f "$log_file" ]; then
        # Read the last recorded datestamp from the log file
        previous_datestamp=$(grep -oP "^Date: \K.*" "$log_file" | tail -n 1)
    fi

    if [ "$datestamp" != "$previous_datestamp" ]; then
        {
            printf "Date: %s\n" "$datestamp"
            printf "%.0s-" {1..40}
            printf "\n"
        } >>"$log_file"
    elif [ -z "$previous_datestamp" ]; then
        # If the log file is empty or doesn't exist, print the datestamp
        {
            printf "Date: %s\n" "$datestamp"
            printf "%.0s-" {1..40}
            printf "\n"
        } >>"$log_file"
    fi

    printf "  %s - Action: %s\n" "$timestamp" "$action" >>"$log_file"
    printf "             Command: %s\n\n" "$command" >>"$log_file"
}
# Function to parse and display logs
display_logs() {
    # Declare an associative array to store logs grouped by date
    declare -A date_logs
    current_date=""

    # Read the log file line by line
    while IFS= read -r line; do
        # If the line starts with "Date:", it indicates a new date section
        if [[ $line =~ ^Date:\ ([0-9]{4}-[0-9]{2}-[0-9]{2})$ ]]; then
            current_date="${BASH_REMATCH[1]}"
            date_logs["$current_date"]+="$line"$'\n'$'\n'
        elif [[ -n $current_date ]]; then
            date_logs["$current_date"]+="$line"$'\n'
        fi
    done <execution_log.syn

    # Sort the dates in reverse order (newest first)
    # shellcheck disable=SC2207
    sorted_dates=($(printf "%s\n" "${!date_logs[@]}" | sort -r))

    # Display the logs for each date in the sorted order
    for date in "${sorted_dates[@]}"; do
        echo "${date_logs[$date]}"
    done
}
# show description box / ascii header
show_description() {
    keyword="$1"

    clear

    art=$(splash "$keyword") # Load ASCII art based on keyword
    if [ "$art" != "ASCII art for '$keyword' not found." ]; then
        echo "$art" # Display ASCII art
    fi
    formatted_description=$(echo -e "$desc" | fold -w 67 -s |
        while IFS= read -r desc; do
            space=$((104 - ${#BLUE} - ${#NC} - ${#desc} - 21)) # 10 characters for other fixed width components
            if [[ $desc == *"$desc"* ]]; then
                echo -e "${BLUE} █▌ █${NC}     ${YELLOW}${desc}${NC} $(printf '%*s' "$space" "") ${BLUE}█ ▐█${NC}"
            fi
        done)

    printf "${BLUE}   $(printf ' %.0s' {1..50})┌──────∙·       ·∙─────┐         ${NC}\n"
    printf "${BLUE}    ▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░${NC} ${RED}Information:${NC} ${BLUE} ░▒▓▓▓▓▓▓▓▄▄   ${NC}\n"
    printf "${BLUE}  ▄▓▓▓▀▀▀▀▀▀▀                                        └┬───────∙·  ·∙───────┬┘ ▀▀▀▀▀▓▓▄${NC}\n"
    printf "${BLUE} ▐▓▀                                                                                 ▀▓▌${NC}\n"
    printf "${BLUE} █▌ ░                                                                               ░ ▐█${NC}\n"
    printf "%s\n" "$formatted_description"
    printf "${BLUE} █  █▌                                                                             ▐█  █${NC}\n"
    printf "${BLUE} █  ▐▓▄    ▄                                                                 ▄    ▄▓▌  █${NC}\n"
    printf "${BLUE} █   ▀▓▓▓▄▄▄█▄                                                             ▄█▄▄▄▓▓▓▀   █${NC}\n"
    printf "${BLUE} ▐▌     ▀▀▓▓▓▓▓▄                                                         ▄▓▓▓▓▓▀▀     ▐▌${NC}\n"
    printf "${BLUE}  ▀▄                                                                                 ▄▀${NC}\n"
    printf "${BLUE}   ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ${NC}\n"

}
# Load user scripts from the scripts directory
load_user_scripts() {
    user_script_options=()
    user_script_options_all=()
    if [ -d "$user_scripts_directory" ]; then
        while IFS= read -r -d '' file; do
            user_script_options_all+=("$(basename "$file")")
        done < <(find "$user_scripts_directory" -maxdepth 1 -type f -executable -print0)
        if [ "${#user_script_options_all[@]}" -gt 7 ]; then
            # Only load the first 7 items for the first page
            user_script_options=("${user_script_options_all[@]:0:7}")
            user_script_options+=("Next Page")
            user_script_options+=("Back")

        else
            user_script_options=("${user_script_options_all[@]}")
            user_script_options+=("Back")
        fi
    fi
}
# Load cheatsheets
load_cheatsheets() {
    cheatsheets_options=()
    cheatsheets_options_all=()
    if [ -d "$cheatsheets_directory" ]; then
        while IFS= read -r -d '' file; do
            cheatsheets_options_all+=("$(basename "$file")")
        done < <(find "$cheatsheets_directory" -maxdepth 1 -type f -executable -print0)
        if [ "${#cheatsheets_options_all[@]}" -gt 7 ]; then
            # Only load the first 7 items for the first page
            cheatsheets_options=("${cheatsheets_options_all[@]:0:7}")
            cheatsheets_options+=("Next Page")
            cheatsheets_options+=("Back")

        else
            cheatsheets_options=("${cheatsheets_options_all[@]}")
            cheatsheets_options+=("Back")
        fi
    fi
}
# Define a variable for the debug log file path
debug_log_file="debug_log.txt"
# Function to log debug messages to the file
log_debug() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >>"$debug_log_file"
}
# load results box
load_saved_results() {
    saved_results_options=()
    saved_results_options_all=()

    if [ -d "$saved_results_directory" ]; then
        num_files=$(find "$saved_results_directory" -maxdepth 1 -type f -executable | wc -l)
        if [ "$num_files" -gt 0 ]; then
            while IFS= read -r -d '' file; do
                filename=$(basename "$file")
                saved_results_options_all+=("$filename")
            done < <(find "$saved_results_directory" -maxdepth 1 -type f -executable -printf "%T@ %p\0" | sort -nrz | cut -d' ' -f2-)

            if [ "${#saved_results_options_all[@]}" -gt 5 ]; then
                # Only load the first 5 items for the first page
                saved_results_options=("${saved_results_options_all[@]:0:5}")
                saved_results_options+=("Next Page")
                saved_results_options+=("Back")
                saved_results_options+=("Delete All")
                saved_results_options+=("Command Logs")
            else
                saved_results_options=("${saved_results_options_all[@]}")
                saved_results_options+=("Back")
                saved_results_options+=("Delete All")
                saved_results_options+=("Command Logs")
            fi
        else
            saved_results_options+=("Back")
            saved_results_options+=("Command Logs")
            # If no files found, show appropriate message or take action
            info_box="No files found in directory."

        fi

    fi
}
# load next page of user scripts
load_next_script() {
    local start_index=$((page_index * 7))
    local remaining_items=("${user_script_options_all[@]:start_index}")

    # Clear the options arrays
    user_script_options=()

    # Load saved results options
    local loaded_items=0
    for item in "${remaining_items[@]}"; do
        if [ -n "$item" ]; then
            user_script_options+=("$item")
            ((loaded_items++))
        fi
        if [ "$loaded_items" -eq 7 ]; then
            break
        fi
    done

    # Add navigation options if needed
    if [ "$loaded_items" -eq 7 ] && [ "$loaded_items" -lt "${#remaining_items[@]}" ]; then
        user_script_options+=("Next Page")
    fi
    if [ "$start_index" -gt 0 ] || [ "$page_index" -gt 0 ]; then
        user_script_options+=("Previous Page")
    fi
    if [ "$page_index" -eq 0 ]; then
        user_script_options+=("Back")
    fi
}
# Load next page of cheatsheets
load_next_cheatsheet() {
    local start_index=$((page_index * 7))
    local remaining_items=("${cheatsheets_options_all[@]:start_index}")

    # Clear the options arrays
    cheatsheets_options=()

    # Load cheatsheet options
    local loaded_items=0
    for item in "${remaining_items[@]}"; do
        if [ -n "$item" ]; then
            cheatsheets_options+=("$item")
            ((loaded_items++))
        fi
        if [ "$loaded_items" -eq 7 ]; then
            break
        fi
    done

    # Add navigation options if needed
    if [ "$loaded_items" -eq 7 ] && [ "$loaded_items" -lt "${#remaining_items[@]}" ]; then
        cheatsheets_options+=("Next Page")
    fi
    if [ "$start_index" -gt 0 ] || [ "$page_index" -gt 0 ]; then
        cheatsheets_options+=("Previous Page")
    fi
    if [ "$page_index" -eq 0 ]; then
        cheatsheets_options+=("Back")
    fi
}
# load next page of saved results
load_next_results() {
    local start_index=$((page_index * 5))
    local remaining_items=("${saved_results_options_all[@]:start_index}")

    # Clear the options arrays
    saved_results_options=()

    # Load saved results options
    local loaded_items=0
    for item in "${remaining_items[@]}"; do
        if [ -n "$item" ]; then
            saved_results_options+=("$item")
            ((loaded_items++))
        fi
        if [ "$loaded_items" -eq 5 ]; then
            break
        fi
    done

    # Add navigation options if needed
    if [ "$loaded_items" -eq 5 ] && [ "$loaded_items" -lt "${#remaining_items[@]}" ]; then
        saved_results_options+=("Next Page")
    fi
    if [ "$start_index" -gt 0 ] || [ "$page_index" -gt 0 ]; then
        saved_results_options+=("Previous Page")
    fi
    if [ "$page_index" -eq 0 ]; then
        saved_results_options+=("Back")
        saved_results_options+=("Delete All")
        saved_results_options+=("Command Logs")
        page_index=0
    fi
}
# load header ascii art
header() {
    printf "${BLUE}                                                     ┌──────∙·      ·∙──────┐          ${NC}\n"
    printf "${BLUE}    ▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░${NC}  ${RED}The ar-SYN-al${NC}   ${BLUE}░▒▓▓▓▓▓▓▄▄ ${NC}\n"
    printf "${BLUE}   ▄▓▓▀▀▀▀▀▀▀                                        └┬───────∙·  ·∙───────┬┘ ▀▀▀▀▀▓▓▄${NC}\n"
    printf "${BLUE}  ▄▓▓        ${NC}${YELLOW}          .                 .                .                 ${NC}${BLUE}        ▓▓▄${NC}\n"
    printf "${BLUE} ▐▓▀${NC}${YELLOW}          _  _ ____|_________ ____  /\_____ __________|____ _ _                ${NC}${BLUE}  ▀▓▌${NC}\n"
    printf "${BLUE} █▌ ░${NC}${YELLOW}                  |              \/                  |                       ${NC}${BLUE}  ░ ▐█${NC}\n"
    printf "${BLUE} █  ▒${NC}${CYAN} _ /\_______________\e[1;36m_______________.________   ____${NC}${CYAN}/\________________ _      ${NC}${BLUE}  ▒  █${NC}\n"
    printf "${BLUE} █  ▒${NC}${CYAN}   \____   \__      \\\\${FILL}__       \__  |   \__  \ |   |${NC}${CYAN}\____    \___    _\       ${NC}${BLUE}  ▒  █${NC}\n"
    printf "${BLUE} █  ▓${NC}${CYAN}    /   |   \|  |    \\\\${FILL}    ____/    :   |     \:   |${NC}${CYAN}  /   |   \ |    |        ${NC}${BLUE}  ▓  █${NC}\n"
    printf "${BLUE} █  █${NC}${CYAN}   /         \       <${FILL}       \_____    :          |${NC}${CYAN} /         \|    |        ${NC}${BLUE}  █  █${NC}\n"
    printf "${BLUE} █  █${NC}${CYAN}  /     ;     \ :    |${FILL}----    \    :   :    \     |${NC}${CYAN}/     :     \    |_____   ${NC}${BLUE}  █  █${NC}\n"
    printf "${BLUE} █  █${NC}${CYAN}  \_____|_____/_|____/${FILL}________/_______/_____:\____|${NC}${CYAN}\_____|_____/__________\  ${NC}${BLUE}  █  █${NC}\n"
    printf "${BLUE} █  █${NC}${CYAN}        |               ${NC}${YELLOW}.${NC}${BLUE}                                |${NC}${YELLOW} .${NC}\e[1;44;36m\e[1;36m© 2024 Psiber_Syn${NC}${BLUE}  █  █${NC}\n"
    printf "${BLUE} █  ▓               ${NC}${YELLOW}_  _  ___|___ ____________ __________ ______|_____ _ _        ${NC}${BLUE}  ▓  █${NC}\n"
    printf "${BLUE} ▓  ▒                        ${NC}${YELLOW}|                                  |                 ${NC}${BLUE}  ▒  ▓${NC}\n"
    printf "${BLUE} ▒  ▒                        ${NC}${YELLOW}:                                  :                 ${NC}${BLUE}  ▒  ▒${NC}\n"
    printf "${BLUE} ▒  ░                                                ┌──────∙·      ·∙──────┐       ░  ▒${NC}\n"
    printf "${BLUE} ░  ▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░${NC} ${RED}%s${NC}%*s${BLUE}  ░▒▓▓▓▓▓▓▓▄▄   ░${NC}\n" "$menu_box" $((13 - ${#menu_box})) ""
    printf "${BLUE}  ▄▓▓▓▀▀▀▀▀▀▀                                        └┬───────∙·  ·∙───────┬┘ ▀▀▀▀▀▓▓▄${NC}\n"
    printf "${BLUE} ▐▓▀                                                                                 ▀▓▌${NC}\n"
    printf "${BLUE} █▌ ░                                                                               ░ ▐█${NC}\n"
    printf "${BLUE} █▌ ▒                                                                               ▒ ▐█${NC}\n"
}
# Load footer ascii art
footer() {
    formatted_prev_cmd=$(echo -e "$previous_command" | fold -w 60 -s |
        while IFS= read -r line; do
            padding=$((97 - ${#BLUE} - ${#NC} - ${#line} - 21))
            if [[ $line == *"$previous_command"* ]]; then
                echo -e "${BLUE} █▌ ▒${NC}            ${YELLOW}${line}${NC} $(printf '%*s' "$padding" "") ${BLUE}▒ ▐█${NC}"
            else
                echo -e "${BLUE} █▌ ░${NC}            ${line} $(printf '%*s' "$padding" "") ${BLUE}░ ▐█${NC}"
            fi
        done)
    clean_info_box=$(echo -e "$info_box" | sed "s/\x1B\[[0-9;]*[a-zA-Z]//g")
    for ((j = 0; j < empty_lines; j++)); do
        printf "${BLUE} █  █$(printf ' %.0s' {1..78}) █  █${NC}\n"
    done

    printf "${BLUE} █  ▓  ${NC}${RED}[m|M] = Main Menu [q|Q] = Quit${NC}${BLUE}$(printf ' %.0s' {1..46}) ▓  █${NC}\n"
    printf "${BLUE} ▓  ▒$(printf ' %.0s' {1..5}) ┌──────∙·     ·∙──────┐$(printf ' %.0s' {1..49}) ▒  ▓${NC}\n"
    printf "${BLUE} ▒  ▒$(printf ' %.0s' {1..5}) │■${NC} ${RED}[⇧/⇩]  +  [Enter]${NC} ${BLUE}■│${NC}    %b%*s${BLUE} ▒  ▒${NC}\n" "$info_box" $((45 - ${#clean_info_box})) ""
    printf "${BLUE} ▒  ░$(printf ' %.0s' {1..5}) └┬──────∙·   ·∙──────┬┘ $(printf ' %.0s' {1..18})┌──────∙·      ·∙──────┐       ░  ▒${NC}\n"
    printf "${BLUE} ░  ▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░${NC}  ${RED}Information:${NC} ${BLUE} ░▒▓▓▓▓▓▓▓▄▄   ░${NC}\n"
    printf "${BLUE}  ▄▓▓▓▀▀▀▀▀▀▀                                        └┬───────∙·  ·∙───────┬┘ ▀▀▀▀▀▓▓▄${NC}\n"
    printf "${BLUE} ▐▓▀                                                                                 ▀▓▌${NC}\n"
    printf "${BLUE} █▌ ░      [${RED} Prev CMD${NC}${BLUE} ]                                                             ░ ▐█${NC}\n"
    printf "%s\n" "$formatted_prev_cmd"
    printf "${BLUE} █  █▌                                                                             ▐█  █${NC}\n"
    printf "${BLUE} █  ▐▓▄    ▄                                                                 ▄    ▄▓▌  █${NC}\n"
    printf "${BLUE} █   ▀▓▓▓▄▄▄█▄                                                             ▄█▄▄▄▓▓▓▀   █${NC}\n"
    printf "${BLUE} ▐▌     ▀▀▓▓▓▓▓▄                                                         ▄▓▓▓▓▓▀▀     ▐▌${NC}\n"
    printf "${BLUE}  ▀▄                                                                                 ▄▀${NC}\n"
    printf "${BLUE}   ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ${NC}\n"
}
# load results ascii art
results() {
    # Display results only if there are actual results to show
    if [ -n "$results" ]; then
        clear
        formatted_results=$(echo -e "$results" | fold -w 67 -s | tr -s ' ' | tr '\t' '     ' | tr -s '\t' | tr -d '\r' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" |
            while IFS= read -r -t .01 line; do
                space=$((100 - ${#BLUE} - ${#NC} - ${#line} - 21)) # 10 characters for other fixed width components
                if [[ $line == *"$line"* ]]; then
                    echo -e "${BLUE} █▌ █${NC}     ${YELLOW}${line}${NC} $(printf '%*s' "$space" "")     ${BLUE}█ ▐█${NC}"
                fi
            done)

        lines_per_page=25 # Number of lines to display per page
        total_lines=$(echo -e "$formatted_results" | wc -l)
        total_pages=$(((total_lines + lines_per_page - 1) / lines_per_page))

        # Function to display pagination of results
        display_page() {
            start_line=$1
            end_line=$2
            echo -e "$formatted_results" | sed -n "${start_line},${end_line}p"

            # Calculate number of lines displayed
            displayed_lines=$(echo -e "$formatted_results" | sed -n "${start_line},${end_line}p" | wc -l)

            # Add padding lines if the number of displayed lines is less than lines_per_page
            if [ "$displayed_lines" -lt $lines_per_page ]; then
                padding_lines=$((lines_per_page - displayed_lines))
                for ((i = 0; i < padding_lines; i++)); do
                    printf "${BLUE} █▌ █${NC}$(printf '%*s' 79 '')${BLUE}█ ▐█${NC}\n"
                done
            fi
        }

        current_page=1

        while [ $current_page -le $total_pages ]; do
            clear
            splash "results"
            printf "${BLUE}   $(printf ' %.0s' {1..50})┌──────∙·      ·∙──────┐         ${NC}\n"
            printf "${BLUE}    ▄▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░${NC}  ${RED} Results:  ${NC}${BLUE} ░▒▓▓▓▓▓▓▓▄▄   ${NC}\n"
            printf "${BLUE}  ▄▓▓▓▀▀▀▀▀▀▀                                        └┬───────∙·  ·∙───────┬┘ ▀▀▀▀▀▓▓▄${NC}\n"
            printf "${BLUE} ▐▓▀                                                                                 ▀▓▌${NC}\n"
            printf "${BLUE} █▌ ░                                                                               ░ ▐█${NC}\n"

            start_line=$(((current_page - 1) * lines_per_page + 1))
            end_line=$((current_page * lines_per_page))
            display_page $start_line $end_line

            printf "${BLUE} █  █▌                                                                             ▐█  █${NC}\n"
            printf "${BLUE} █  ▐▓▄    ▄                                                                 ▄    ▄▓▌  █${NC}\n"
            printf "${BLUE} █   ▀▓▓▓▄▄▄█▄                                                             ▄█▄▄▄▓▓▓▀   █${NC}\n"
            printf "${BLUE} ▐▌     ▀▀▓▓▓▓▓▄                                                         ▄▓▓▓▓▓▀▀     ▐▌${NC}\n"
            # Display page number at the bottom
            if [ $total_pages -gt 1 ]; then
                printf "${BLUE}  ▀▄     ${NC}                          [   ${RED}Page $current_page of $total_pages${NC}   ]   ${BLUE}                           ▄▀${NC}\n"
            else
                printf "${BLUE}  ▀▄                                                                                 ▄▀${NC}\n"
            fi
            printf "${BLUE}   ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ${NC}\n"

            # Navigation for specific menu
            if [ $current_page -lt $total_pages ]; then
                echo -e "\n${START} ${RED}Press any key to go to the next page, \"Q|q\" to exit.${NC} ${END}"

            elif [ "$view" = "true" ]; then
                echo -e "\n${START} ${RED}Press any key to go back${NC} ${END}"
            elif [ "$current_menu" = "saved_results" ]; then
                echo -e "\n${START} ${RED}End of file reached, press any key to go back to menu.${NC} ${END}"

            elif [ "$current_menu" = "network_tools" ]; then
                if [ -f /etc/hosts.backup_temporary ]; then
                    echo -e "${GREEN}New${RED} hosts file created. ${NC}"
                    echo -e "\n${START} ${RED}Press any key to go back${NC} ${END}"
                else
                    echo -e "${RED}Hosts file ${GREEN}restored.${NC}"
                    echo -e "(File is $(sudo cat /etc/hosts | wc -l) lines long.)"
                    echo -e "\n${START} ${RED}Press any key to go back${NC} ${END}"
                fi

            else
                handle_save_results "$target"

            fi

            read -rsn1 input
            if [[ $input == 'q' ]]; then
                break
            fi

            current_page=$((current_page + 1))
        done

        results=""
        clear

        display_menu
        page_index=0
        selected_index=0
    fi
}

# Cheatsheet display
cheatsheets() {
    file="$1"
    line_length=109
    page_size=20

    if [[ ! -f "$file" ]]; then
        echo "File not found!"
        return 1
    fi

    # Check if the file has a .pdf extension
    if [[ "$file" == *.pdf ]]; then
        # Convert PDF to text using pdftotext
        content=$(pdftotext "$file" -)
    else
        # Read file content for non-PDF files
        content=$(cat "$file")
    fi
    # Remove control characters and ANSI color codes, replace tabs with spaces
    clean_content=$(echo "$content" | sed -r 's/\x1B\[[0-9;]*[mK]//g' | tr -d '\r' | expand)

    # Wrap lines to the specified length
    wrapped_content=$(echo "$clean_content" | fold -s -w "$line_length")

    # Calculate padding for the file name line
    file_name=$(basename "$file" | sed 's/\.[^.]*$//')
    file_name_padding=$((line_length - ${#file_name} - 17))

    # Add ASCII graphical frame
    frame_line="${BLUE}
               ███                  ███                 ███                 ███                  ███
               █ ██                ██ █                ██ ██                █ ██                ██ █                                                          
               █ ██                ██ █                ██ ██                █ ██                ██ █                   
      ██████████ ████████████████████ ███████████████████ ███████████████████ ████████████████████ ██████████                                                 
   ████        █ ██                ██ █                ██ ██                █ ██                ██ █        ████                                              
 ███           █ ██                ██ █                ██ ██                █ ██                ██ █           ███                                            
 █           ███ ████            ████ ███            ████ ████            ███ ████            ████ ███           █                                            
██         ██  █ ██  ██        ██  ██ █  ██         ██  █ █  ██         ██  █ ██  ██        ██  ██ █  ██         ██                                           
██        ██   █ ██   ██      ██   ██ █   ██       ██  ██ ██  ██       ██   █ ██   ██      ██   ██ █   ██        ██                                           
██        ██    ██    ██      ██    ██    ██       ██   ███   ██       ██    ██    ██      ██    ██    ██        ██                                           
██         ██        ██        ██        ██         ██       ██         ██        ██        ██        ██         ██                                           
██           ████████            ████████             ███████             ████████            ████████           ██                                           
██${NC}${RED}        ___ _             _   ___ _            _${NC}${BLUE}                                                               ██
██${NC}${RED}	 / __| |_  ___ __ _| |_/ __| |_  ___ ___| |_ ___ ${NC}${BLUE}                                                        ██ 
██${NC}${RED}	| (__| ' \/ -_) _\` |  _\__ \ ' \/ -_) -_)  _(_-< ${NC}${BLUE}                                                        ██
██${NC}${RED}	 \___|_||_\___\__,_|\__|___/_||_\___\___|\__/__/ ${NC}${BLUE}                                                        ██                                           
██_______________________________________________________________________________________________________________██                                           
██                                                                                                               ██
██ ${RED}         Viewing: $file_name$(printf "%${file_name_padding}s" "")${BLUE}██ ${NC}"

    frame_line_end="${BLUE}██                                                                                                               ██                                           
██                                                                                                               ██                                           
 █                                                                                                               █                                           
 ██                                                                                                             ██ ${NC}"

    # Function to add frame around content
    add_frame() {
        echo -e "$frame_line"
        line_count=0
        while IFS= read -r line; do
            # Trim trailing spaces
            trimmed_line=$(echo "$line" | sed 's/[[:space:]]*$//')

            # Calculate the length of the line after trimming
            trimmed_length=${#trimmed_line}

            # Calculate the number of spaces needed for padding
            padding=$((line_length - trimmed_length))

            # Construct the padded line with proper alignment
            padded_line="${trimmed_line}$(printf "%${padding}s" "")"

            # Output the line with frame
            printf "${BLUE}██${NC} %s ${BLUE}██${NC}\n" "$padded_line"
            line_count=$((line_count + 1))
        done

        # Pad with empty lines if necessary to maintain static frame size
        while [ "$line_count" -lt "$page_size" ]; do
            printf "${BLUE}██${NC} %-*s ${BLUE}██${NC}\n" "$line_length" ""
            line_count=$((line_count + 1))
        done

        echo -e "$frame_line_end"
    }

    # Paginate the content and add frame for each page
    total_lines=$(echo "$wrapped_content" | wc -l)
    total_pages=$(((total_lines + page_size - 1) / page_size))
    current_page=1

    while [ "$current_page" -le "$total_pages" ]; do
        start_line=$(((current_page - 1) * page_size + 1))
        end_line=$((current_page * page_size))
        page_content=$(echo "$wrapped_content" | sed -n "${start_line},${end_line}p")

        clear
        echo "$page_content" | add_frame

        # Add page number at the bottom if more than one page
        if [ "$total_pages" -gt 1 ]; then
            page_info="[   Page $current_page of $total_pages   ]"
            if [ "$current_page" -gt 9 ]; then
                padding=$((line_length - ${#page_info} - 47))
            elif [ "$total_pages" -gt 9 ]; then
                padding=$((line_length - ${#page_info} - 48))
            else
                padding=$((line_length - ${#page_info} - 48))
            fi
            printf "${BLUE}  ███${NC} %-${padding}s${RED}%s${NC} %-${padding}s${BLUE}███${NC}\n" "" "$page_info" ""
            printf "${BLUE}     █████████████████████████████████████████████████████████████████████████████████████████████████████████${NC}\n"
        else
            printf "${BLUE}  ███                                                                                                         ███${NC}\n"
            printf "${BLUE}     █████████████████████████████████████████████████████████████████████████████████████████████████████████${NC}\n"
        fi

        current_page=$((current_page + 1))
        if [ "$current_page" -le "$total_pages" ]; then
            echo -e "\n${START} ${RED}Press any key to go to the next page, \"Q|q\" to exit.${NC} ${END}"
            
            read -rsn1 quit
            if [[ $quit == 'q' || $quit == 'Q' ]]; then
                clear
                display_menu
                return 0
            fi
        else
            echo -e "\n${START} ${RED}End of file reached, press any key to go back to menu.${NC} ${END}"
            read -rsn1 input
        fi
    done

    clear

    display_menu

}

# Display the menu
display_menu() {
    tput clear
    echo -ne '\033[?25l'
    header
    local total_menu_lines=20
    local num_options=0
    local empty_lines=0

    case $current_menu in
    "main")
        options=("${main_options[@]}")
        ;;
    "scanners")
        options=("${scanners_options[@]}")
        ;;
    "enum_scans")
        options=("${enum_scans_options[@]}")
        ;;
    "enum_web")
        options=("${enum_web_options[@]}")
        ;;
    "enum_dns")
        options=("${enum_dns_options[@]}")
        ;;
    "enum_file")
        options=("${enum_file_options[@]}")
        ;;
    "nmap_scans")
        options=("${nmap_scans_options[@]}")
        ;;
    "basic_scan_submenu")
        options=("${basic_scan_submenu_options[@]}")
        ;;
    "advanced_scan_submenu")
        options=("${advanced_scan_submenu_options[@]}")
        ;;
    "scripting_scan_submenu")
        options=("${scripting_scan_submenu_options[@]}")
        ;;
    "vuln_scanning")
        options=("${vuln_scanning_options[@]}")
        ;;
    "password_cracking")
        options=("${password_cracking_options[@]}")
        ;;
    "network_tools")
        options=("${network_tools_options[@]}")
        ;;
    "cheatsheets")
        options=("${cheatsheets_options[@]}")
        ;;
    "user_scripts")
        options=("${user_script_options[@]}")
        ;;
    "fun_zone")
        options=("${fun_zone_options[@]}")
        ;;
    "saved_results")
        options=("${saved_results_options[@]}")
        ;;
    esac
    num_options=${#options[@]}
    empty_lines=$((total_menu_lines - num_options - 10)) # 10 lines are occupied by fixed text

    for ((i = 0; i < num_options; i++)); do
        if [ $i -eq $selected_index ]; then
            printf "${BLUE} █  █${NC}      ${RED}${TRIANGLE}${NC} ${YELLOW}[$((i + 1))]${NC} \e[1m\e[44m${options[i]}${NC} %*s${BLUE}  █  █${NC}\n" $((${#options[i]} - 64)) " "

            case ${options[$i]} in
            ###### Main Menu
            "Scanners")
                info_box="${START} ${RED}Select the type of Scanner${NC} ${END}"
                ;;
            "Vulnerability Scanning")
                info_box="${START} ${RED}Choose a vulnerability scanner${NC} ${END}"
                ;;
            "Password Cracking")
                info_box="${START} ${RED}Select a password cracker${NC} ${END}"
                ;;
            "Network Tools")
                info_box="${START} ${RED}Choose a network tool${NC} ${END}"
                ;;
            "Cheatsheets")
                info_box="${START} ${RED}Select Cheatsheet to view${NC} ${END}"
                ;;
            "User Scripts")
                info_box="${START} ${RED}Select a user script to execute${NC} ${END}"
                ;;
            "Fun Zone")
                info_box="${START} ${RED}W${NC}${ORANGE}e${NC}${YELLOW}l${NC}${GREEN}c${NC}${BLUE}o${NC}${INDIGO}m${NC}${VIOLET}e${NC} ${RED}T${NC}${ORANGE}o${NC} ${YELLOW}T${NC}${GREEN}h${NC}${BLUE}e${NC} ${INDIGO}F${NC}${BLUE}u${NC}${INDIGO}n${NC} ${VIOLET}Z${NC}${RED}o${NC}${ORANGE}n${NC}${YELLOW}e${NC} ${END}"
                ;;
            "Saved Results")
                info_box="${START} ${RED}Select saved results to view${NC} ${END}"
                ;;
            "Delete All")
                info_box="${START} ${RED}Delete all saved results${NC} ${END}"
                ;;
            "Command Logs")
                info_box="${START} ${RED}View previous command logs${NC} ${END}"
                ;;
            "Next Page")
                info_box="${START} ${RED}Next Page${NC} ${END}"
                ;;
            "Previous Page")
                info_box="${START} ${RED}Previous Page${NC} ${END}"
                ;;
            "Exit")
                info_box="${START} ${RED}Exiting${NC} ${END}"
                ;;
            ###### Vulnerability Scanning menu
            "Nikto Scan")
                info_box="${START} ${RED}Nikto vulnerability scan${NC} ${END}"
                ;;
            "SQLmap")
                info_box="${START} ${RED}SQLmap vulnerability scan${NC} ${END}"
                ;;
            "WPScan")
                info_box="${START} ${RED}WPScan vulnerability scan${NC} ${END}"
                ;;
            ###### Password Cracking menu
            "John the Ripper")
                info_box="${START} ${RED}Crack passwords with JTR${NC} ${END}"
                ;;
            "Hashcat")
                info_box="${START} ${RED}Crack passwords with Hashcat${NC} ${END}"
                ;;
            "Hydra")
                info_box="${START} ${RED}Perform Hydra attack${NC} ${END}"
                ;;
            "Medusa")
                info_box="${START} ${RED}Perform Medusa attack${NC} ${END}"
                ;;
            "CeWL")
                info_box="${START} ${RED}Create CeWL wordlist${NC} ${END}"
                ;;
            "Hash-ID")
                info_box="${START} ${RED}Perform Hash-ID Identifier${NC} ${END}"
                ;;
            ###### Network tools Menu
            "ifconfig")
                info_box="${START} ${RED}View ifconfig${NC} ${END}"
                ;;
            "Hosts file")
                info_box="${START} ${RED}View/Edit Hosts file${NC} ${END}"
                ;;
            "geoIP")
                info_box="${START} ${RED}Geolocation by IP${NC} ${END}"
                ;;
            ###### Scanners Menu
            "Ping Sweep")
                info_box="${START} ${RED}Scan the subnet for active IPs${NC} ${END}"
                ;;
            "Total Nmap Scan")
                info_box="${START} ${RED}Total Nmap scan${NC} ${END}"
                ;;
            "Nmap Scans")
                info_box="${START} ${RED}Select a Nmap scan${NC} ${END}"
                ;;
            ###### Enumeration Scans Menu
            "Enumeration")
                info_box="${START} ${RED}Enumeration tool${NC} ${END}"
                ;;
            ###### Enumeration Web menu
            "GoBuster")
                info_box="${START} ${RED}GoBuster scan${NC} ${END}"
                ;;
            "FFuF")
                info_box="${START} ${RED}FFuF scan${NC} ${END}"
                ;;
            "wFuzz")
                info_box="${START} ${RED}wFuzz scan${NC} ${END}"
                ;;
            "DirB")
                info_box="${START} ${RED}Dirb scan${NC} ${END}"
                ;;
            ###### Enumeeration DNS menu
            "Dig")
                info_box="${START} ${RED}Dig query${NC} ${END}"
                ;;
            "DNSenum")
                info_box="${START} ${RED}DNSenum scan${NC} ${END}"
                ;;
            "DNSrecon")
                info_box="${START} ${RED}DNSrecon scan${NC} ${END}"
                ;;
            "DNSmap")
                info_box="${START} ${RED}DNSmap scan${NC} ${END}"
                ;;
            "theHarvester")
                info_box="${START} ${RED}theHarvester scan${NC} ${END}"
                ;;
            ###### Enumeration File menu
            "DotDotPwn")
                info_box="${START} ${RED}DotDotPwn scan${NC} ${END}"
                ;;
            "SearchSploit")
                info_box="${START} ${RED}SearchSploit${NC} ${END}"
                ;;
            ###### Nmap Scans main scanners/nmap scan
            "Basic Scans")
                info_box="${START} ${RED}Basic Nmap scans${NC} ${END}"
                ;;
            "Advanced Scans")
                info_box="${START} ${RED}Advanced Nmap scans${NC} ${END}"
                ;;
            "Scripted Scans")
                info_box="${START} ${RED}Scripted Nmap scans${NC} ${END}"
                ;;
            "Aggressive Scan")
                info_box="${START} ${RED}Aggressive Nmap scan${NC} ${END}"
                ;;
            ###### Nmap Basic Scans submenu scanners/nmap scan/basic
            "Basic Nmap Scan")
                info_box="${START} ${RED}Basic Nmap scan${NC} ${END}"
                ;;
            "Fast Nmap Scan")
                info_box="${START} ${RED}Fast Nmap scan${NC} ${END}"
                ;;
            "TCP Nmap Scan")
                info_box="${START} ${RED}TCP Nmap scan${NC} ${END}"
                ;;
            "UDP Nmap Scan")
                info_box="${START} ${RED}UDP Nmap scan${NC} ${END}"
                ;;
            "Active Host Network Nmap Scan")
                info_box="${START} ${RED}Active local host Nmap scan${NC} ${END}"
                ;;
            "IP Protocol Nmap Scan")
                info_box="${START} ${RED}IP protocol Nmap scan${NC} ${END}"
                ;;
            "TCP ACK Nmap Scan")
                info_box="${START} ${RED}TCP ACK Nmap scan${NC} ${END}"
                ;;
            "Service Version Detection")
                info_box="${START} ${RED}Service version detection${NC} ${END}"
                ;;
            ###### Nmap Advanced Scans submenu scanners/nmap scan/advanced
            "Stealth Scan")
                info_box="${START} ${RED}Nmap Stealth scan${NC} ${END}"
                ;;
            "IP/Mac Spoofing Scan")
                info_box="${START} ${RED}Nmap IP/Mac spoofing${NC} ${END}"
                ;;
            ###### Nmap Scripted Scans submenu scanners/nmap scan/scripted
            "HTTP site map Generator")
                info_box="${START} ${RED}HTTP site map ${NC} ${END}"
                ;;
            "Nmap XSS Scan")
                info_box="${START} ${RED}Nmap XSS scan${NC} ${END}"
                ;;
            "Nmap SQL Scan")
                info_box="${START} ${RED}Nmap SQL scan${NC} ${END}"
                ;;
            ###### Fun Zone
            "Joker Bomb")
                info_box="${START} ${RED}Why so Serious?${NC} ${END}"
                ;;
            "Matrix")
                info_box="${START} ${GREEN}Wake up Neo!${NC} ${END}"
                ;;
            "Clock")
                info_box="${START} Whos got the ${BLUE}time${NC}? ${END}"
                ;;
            "Tetris")
                info_box="${START} ${RED}Play Tetris${NC} ${END}"
                ;;
            "Weather Man")
                info_box="${START} ❄️ ☀️ ${BLUE}Is it Raining?${NC} ☀️ ❄️ ${END}"
                ;;
            "ASCII STAR WARS")
                info_box="${START} ${RED}Watch ASCII Star Wars${NC} ${END}"
                ;;
            "Install Tools")
                info_box="${START} ${RED}Install required tools${NC} ${END}"
                ;;
            "Back")
                if [ "$current_menu" = "nmap_scans" ]; then
                    info_box="${START} ${RED}Back to Scanners ${NC} ${END}"
                elif [ "$current_menu" = "basic_scan_submenu" ]; then
                    info_box="${START} ${RED}Back to Nmap Scans ${NC} ${END}"
                elif [ "$current_menu" = "advanced_scan_submenu" ]; then
                    info_box="${START} ${RED}Back to Nmap Scans ${NC} ${END}"
                elif [ "$current_menu" = "scripting_scan_submenu" ]; then
                    info_box="${START} ${RED}Back to Nmap Scans ${NC} ${END}"
                elif [ "$current_menu" = "enum_scans" ]; then
                    info_box="${START} ${RED}Back to Scanners ${NC} ${END}"
                elif [ "$current_menu" = "enum_dns" ]; then
                    info_box="${START} ${RED}Back to Scanners ${NC} ${END}"
                elif [ "$current_menu" = "enum_file" ]; then
                    info_box="${START} ${RED}Back to Scanners ${NC} ${END}"
                elif [ "$current_menu" = "enum_web" ]; then
                    info_box="${START} ${RED}Back to Scanners$ {NC} ${END}"
                else
                    info_box="${START} ${RED}Back to main menu${NC} ${END}"
                fi
                ;;
            "Main Menu")
                info_box="${START} ${RED}Back to main menu${NC} ${END}"
                ;;

            esac
        else
            printf "${BLUE} █  █${NC}           ${YELLOW}[$((i + 1))]${NC} \e[1m${options[i]}${NC}%*s${BLUE}  █  █${NC}\n" $((${#options[i]} - 62)) " "
        fi
    done
    footer
}
# Register CTRL+C event handler
trap on_ctrl_c SIGINT
# Function to handle user input
handle_input() {
    read -rsn1 input
    case $input in
    "A") # Up arrow key
        if [ $selected_index -gt 0 ]; then
            ((selected_index--))
        else
            selected_index=$((${#options[@]} - 1))
        fi

        # hack to fix info_box
        if [ "$current_menu" = "saved_results" ]; then
            info_box="${START} ${RED}Select saved results to view${NC} ${END}"

        elif [ "$current_menu" = "user_scripts" ]; then
            info_box="${START} ${RED}Select a user script to execute${NC} ${END}"

        elif [ "$current_menu" = "cheatsheets" ]; then
            info_box="${START} ${RED}Select a Cheatsheet to view${NC} ${END}"
        fi
        ;;
    "B") # Down arrow key
        if [ $selected_index -lt $((${#options[@]} - 1)) ]; then
            ((selected_index++))
        else
            selected_index=0
        fi

        # hack to fix info_box
        if [ "$current_menu" = "saved_results" ]; then
            info_box="${START} ${RED}Select saved results to view${NC} ${END}"

        elif [ "$current_menu" = "user_scripts" ]; then
            info_box="${START} ${RED}Select a user script to execute${NC} ${END}"

        elif [ "$current_menu" = "cheatsheets" ]; then
            info_box="${START} ${RED}Select a Cheatsheet to view${NC} ${END}"
        fi
        ;;
    "Q" | "q")
        if [ "$current_menu" = "cheatsheets" ]; then
            clear
            display_menu
            return
        else 
            echo -ne '\033[?25h'
            clear
            exit 0
        fi
        ;;
    "M" | "m")
        current_menu="main"
        selected_index=0
        menu_box="   Main Menu"
        page_index=0
        results=""
        ;;

    "") # Enter key
        case $current_menu in
        "main")
            if [ "${main_options[selected_index]}" = "Exit" ]; then
                echo -ne '\033[?25h'
                clear
                exit 0
            else
                load_saved_results
                load_user_scripts
                load_cheatsheets
                enter_submenu
            fi
            ;;
        ############  Main Menu Items
        "scanners")
            perform_action_scanners
            ;;
        "vuln_scanning")
            perform_action_vuln_scanning
            ;;
        "password_cracking")
            perform_action_password_cracking
            ;;
        "network_tools")
            perform_action_network_tools
            ;;
        "user_scripts")
            if [ "${user_script_options[selected_index]}" = "Next Page" ]; then
                ((page_index++))
                load_next_script $page_index
                selected_index=0
            elif [ "${user_script_options[selected_index]}" = "Previous Page" ]; then
                ((page_index--))
                load_next_script $page_index
                selected_index=0
            else
                perform_action_user_scripts
            fi
            ;;
        "cheatsheets")
            if [ "${cheatsheets_options[selected_index]}" = "Next Page" ]; then
                ((page_index++))
                load_next_cheatsheet $page_index
                selected_index=0
            elif [ "${cheatsheets_options[selected_index]}" = "Previous Page" ]; then
                ((page_index--))
                load_next_cheatsheet $page_index
                selected_index=0
            else
                perform_action_cheatsheets
            fi
            ;;
        "fun_zone")
            perform_action_fun_zone
            ;;
        "saved_results")
            if [ "${saved_results_options[selected_index]}" = "Next Page" ]; then
                ((page_index++))
                load_next_results $page_index
                selected_index=0
            elif [ "${saved_results_options[selected_index]}" = "Previous Page" ]; then
                ((page_index--))
                load_next_results $page_index
                selected_index=0
            else
                load_saved_results
                perform_action_saved_results
            fi
            ;;
        ######### Nmap Menu
        "nmap_scans")
            perform_action_nmap
            ;;
        ######### Nmap Submenu
        "basic_scan_submenu")
            perform_action_basic_scan_submenu
            ;;
        "advanced_scan_submenu")
            perform_action_advanced_scan_submenu
            ;;
        "scripting_scan_submenu")
            perform_action_scripting_scan_submenu
            ;;
        ######### Enumeration menu
        "enum_scans")
            perform_action_enum_scans
            ;;
        "enum_web")
            perform_action_enum_web
            ;;
        "enum_dns")
            perform_action_enum_dns
            ;;
        "enum_file")
            perform_action_enum_file
            ;;
        "Back")
            enter_submenu
            ;;
        "Main Menu")
            enter_submenu
            ;;
        esac
        ;;
    esac

}
##################### End User input handler
##################### Menu Functions
# Function to enter the submenu of the highlighted main menu item
enter_submenu() {
    case ${options[selected_index]} in
    ####### Main Menu
    "Scanners")
        current_menu="scanners"
        selected_index=0
        menu_box="   Scanners"
        results=""
        ;;
    "Vulnerability Scanning")
        current_menu="vuln_scanning"
        selected_index=0
        menu_box="Vulnerability"
        results=""
        ;;
    "Password Cracking")
        current_menu="password_cracking"
        selected_index=0
        menu_box="   Cracking"
        results=""
        ;;
    "Network Tools")
        current_menu="network_tools"
        selected_index=0
        menu_box="Network Tools"
        results=""
        ;;
    "User Scripts")
        current_menu="user_scripts"
        selected_index=0
        menu_box=" User Scripts"
        results=""
        ;;
    "Cheatsheets")
        current_menu="cheatsheets"
        selected_index=0
        menu_box=" CheatSheets"
        results=""
        ;;
    "Fun Zone")
        current_menu="fun_zone"
        selected_index=0
        menu_box="   Fun Zone"
        results=""
        ;;
    "Saved Results")
        current_menu="saved_results"
        selected_index=0
        menu_box="Saved Results"
        results=""
        ;;
    ######## scanners/Nmap submenu
    "Nmap Scans")
        current_menu="nmap_scans"
        selected_index=0
        menu_box="  Nmap Scans"
        results=""
        ;;
    ####### scanners/nmap/basic submenu
    "Basic Scans")
        current_menu="basic_scan_submenu"
        selected_index=0
        menu_box="  Basic Nmap"
        results=""
        ;;
    ####### scanners/nmap/advanced submenu
    "Advanced Scans")
        current_menu="advanced_scan_submenu"
        selected_index=0
        menu_box="Advanced Nmap"
        results=""
        ;;
    ####### scanners/nmap/scripting submenu
    "Scripted Scans")
        current_menu="scripting_scan_submenu"
        selected_index=0
        menu_box="Scripted Nmap"
        results=""
        ;;
    ####### scanners/enumeration menu
    "Enumeration")
        current_menu="enum_scans"
        selected_index=0
        menu_box=" Enumeration"
        results=""
        ;;
    ####### scanners/enumeration/dns
    "DNS")
        current_menu="enum_dns"
        selected_index=0
        menu_box="   DNS Enum"
        results=""
        ;;
    ####### scanners/enumeration/file
    "File System")
        current_menu="enum_file"
        selected_index=0
        menu_box="  File Enum"
        results=""
        ;;
    ####### scanners/enumeration/web
    "Web")
        current_menu="enum_web"
        selected_index=0
        menu_box="   Web Enum"
        results=""
        ;;
    ####### navigation
    "Back")
        current_menu="main"
        selected_index=0
        menu_box="   Main Menu"
        results=""
        ;;
    "Main Menu")
        current_menu="main"
        selected_index=0
        menu_box="   Main Menu"
        results=""
        ;;
    esac
}
# Function to perform actions for Scanners menu options
perform_action_scanners() {
    case ${scanners_options[selected_index]} in
    "Ping Sweep")
        perform_fPing
        ;;
    "Nmap Scans")
        enter_submenu
        ;;
    "Enumeration")
        enter_submenu
        ;;
    "Back")
        enter_submenu
        ;;
    esac
}
# Function to perform actions for Scanners Nmap submenu options
perform_action_nmap() {
    case ${nmap_scans_options[selected_index]} in
    "Basic Scans")
        enter_submenu
        ;;
    "Advanced Scans")
        enter_submenu
        ;;
    "Scripted Scans")
        enter_submenu
        ;;
    "Total Nmap Scan")
        perform_total_nmap_scan
        ;;
    "Back")
        current_menu="scanners" # Go back to the Scanners submenu
        selected_index=0
        menu_box="    Scanners"
        results=""
        ;;
    "Main Menu")
        enter_submenu
        ;;
    esac
}
# Function to perform actions for Scanner Nmap Basic Scan submenu options
perform_action_basic_scan_submenu() {
    case ${basic_scan_submenu_options[selected_index]} in
    "Basic Nmap Scan")
        perform_nmap_basic_scan
        ;;
    "Service Version Detection")
        perform_nmap_service_version_detection
        ;;
    "Fast Nmap Scan")
        perform_nmap_fast_scan
        ;;
    "TCP Nmap Scan")
        perform_nmap_tcp_scan
        ;;
    "UDP Nmap Scan")
        perform_nmap_udp_scan
        ;;
    "Active Host Network Nmap Scan")
        perform_nmap_active_host_scan
        ;;
    "TCP ACK Nmap Scan")
        perform_nmap_tcp_ack_scan
        ;;
    "Back")
        current_menu="nmap_scans" # Go back to the nmap submenu
        selected_index=0
        menu_box="  Nmap Scans"
        results=""
        ;;
    "Main Menu")
        enter_submenu
        ;;
    esac
}
# Function to perform actions for Scanners Nmap Advanced Scan submenu options
perform_action_advanced_scan_submenu() {
    case ${advanced_scan_submenu_options[selected_index]} in
    "IP Protocol Nmap Scan")
        perform_nmap_ip_protocol_scan
        ;;
    "Stealth Scan")
        perform_nmap_stealth_scan
        ;;
    "IP/Mac Spoofing Scan")
        perform_nmap_spoofing_scan
        ;;
    "Aggressive Scan")
        perform_nmap_aggressive_scan
        ;;
    "Back")
        current_menu="nmap_scans" # Go back to the nmap submenu
        selected_index=0
        menu_box="  Nmap Scans"
        results=""
        ;;
    "Main Menu")
        current_menu="main" # Go back to the main menu
        selected_index=0
        menu_box="   Main Menu"
        results=""
        ;;
    esac
}
# Function to perform actions for Scanners Nmap Scripted Scan submenu options
perform_action_scripting_scan_submenu() {
    case ${scripting_scan_submenu_options[selected_index]} in
    "HTTP site map Generator")
        perform_http_site_map_generator
        ;;
    "Nmap XSS Scan")
        perform_nmap_xss_scan
        ;;
    "Nmap SQL Scan")
        perform_nmap_sql_scan
        ;;
    "Back")
        current_menu="nmap_scans" # Go back to the nmap submenu
        selected_index=0
        menu_box="  Nmap Scans"
        results=""
        ;;
    "Main Menu")
        current_menu="main" # Go back to the main menu
        selected_index=0
        menu_box="   Main Menu"
        results=""
        ;;
    esac
}
# Function to perform actions for Enumeration menu options
perform_action_enum_scans() {
    case ${enum_scans_options[selected_index]} in
    "DNS")
        enter_submenu
        ;;
    "File System")
        enter_submenu
        ;;
    "Web")
        enter_submenu
        ;;
    "Back")
        current_menu="scanners" # Go back to the Scanners submenu
        selected_index=0
        menu_box="   Scanners"
        results=""
        ;;
    "Main Menu")
        enter_submenu
        ;;
    esac
}
# Function to perform actions for Enumeration DNS submenu options
perform_action_enum_dns() {
    case ${enum_dns_options[selected_index]} in
    "Dig")
        perform_dig
        ;;
    "DNSenum")
        perform_dns_enum
        ;;
    "DNSrecon")
        perform_dns_recon
        ;;
    "DNSmap")
        perform_dns_map
        ;;
    "theHarvester")
        perform_harvest
        ;;
    "Back")
        current_menu="enum_scans" # Go back to the Scanners submenu
        selected_index=0
        menu_box=" Enumeration"
        results=""
        ;;
    "Main Menu")
        enter_submenu
        ;;
    esac
}
# Function to perform actions for Enumeration File System submenu options
perform_action_enum_file() {
    case ${enum_file_options[selected_index]} in
    "DotDotPwn")
        perform_dotdotpwn
        ;;
    "SearchSploit")
        perform_searchsploit
        ;;
    "Back")
        current_menu="enum_scans" # Go back to the Scanners submenu
        selected_index=0
        menu_box=" Enumeration"
        results=""
        ;;
    "Main Menu")
        enter_submenu
        ;;
    esac
}
# Function to perform actions for Enumeration Web submenu options
perform_action_enum_web() {
    case ${enum_web_options[selected_index]} in
    "GoBuster")
        perform_gobuster
        ;;
    "DirB")
        perform_dirb
        ;;
    "FFuF")
        perform_ffuf
        ;;
    "wFuzz")
        perform_wfuzz
        ;;
    "Back")
        current_menu="enum_scans" # Go back to the Scanners submenu
        selected_index=0
        menu_box=" Enumeration"
        results=""
        ;;
    "Main Menu")
        enter_submenu
        ;;
    esac
}
# Function to perform actions for vulnerability scanning menu options
perform_action_vuln_scanning() {
    case ${vuln_scanning_options[selected_index]} in
    "Nikto Scan")
        perform_nikto_scan
        ;;
    "SQLmap")
        perform_sqlmap_scan
        ;;
    "WPScan")
        perform_wpscan
        ;;
    "Back")
        enter_submenu
        ;;
    esac
}
# Function to perform actions for password cracking menu options
perform_action_password_cracking() {
    case ${password_cracking_options[selected_index]} in
    "John the Ripper")
        perform_john_the_ripper
        ;;
    "Hashcat")
        perform_hashcat
        ;;
    "Hydra")
        perform_hydra
        ;;
    "Medusa")
        perform_medusa
        ;;
    "CeWL")
        perform_cewl
        ;;
    "Hash-ID")
        perform_hash_id
        ;;
    "Back")
        enter_submenu
        ;;
    esac
}
# Function to perform actions for network sniffing menu options
perform_action_network_tools() {
    case ${network_tools_options[selected_index]} in
    "ifconfig")
        perform_ifconfig
        ;;
    "Hosts file")
        perform_hosts
        ;;
    "geoIP")
        perform_geo
        ;;
    "Back")
        enter_submenu
        ;;
    esac
}
# Function to perform actions for cheatsheets options
perform_action_cheatsheets() {
    case ${cheatsheets_options[selected_index]} in
    "Back")
        enter_submenu
        ;;
    *)
        selected_cheatsheet="${cheatsheets_options[selected_index]}"
        if [ "$selected_cheatsheet" != "Back" ] && [ "$selected_cheatsheet" != "Next Page" ] && [ "$selected_cheatsheet" != "Previous Page" ]; then
            cheatsheet_path="./$cheatsheets_directory/$selected_cheatsheet"
            cheatsheets "$cheatsheet_path"
        fi
        ;;

    esac
}
# Function to perform actions for user scripts options
perform_action_user_scripts() {

    case ${user_script_options[selected_index]} in
    "Back")
        enter_submenu
        ;;
    *)
        selected_script="${user_script_options[selected_index]}"
        if [ "$selected_script" != "Back" ] && [ "$selected_script" != "Next Page" ] && [ "$selected_script" != "Previous Page" ]; then
            script_path="./$user_scripts_directory/$selected_script"

            # Determine the interpreter based on the file extension
            case "$selected_script" in
            *.sh)
                interpreter="bash"
                ;;
            *.py)
                interpreter="python3"
                ;;
            *.pl)
                interpreter="perl"
                ;;
            *.rb)
                interpreter="ruby"
                ;;
            *.php)
                interpreter="php"
                ;;
            *)
                echo "Unsupported script type for file: $selected_script"
                exit 1
                ;;
            esac

            # Initialize an empty array to store arguments
            arguments=()

            # Ask the user for arguments until they press Enter
            while true; do
                read -p "Enter an argument one at the time for the script '$selected_script' (press Enter to finish): " arg
                # If the user pressed Enter without entering an argument, break the loop
                [ -z "$arg" ] && break
                # Add the argument to the array
                arguments+=("$arg")
            done

            # If there are arguments, execute the script
            if [ ${#arguments[@]} -gt 0 ]; then
                echo "Running script: $script_path with arguments: ${arguments[*]}"
                "$interpreter" "$script_path" "${arguments[@]}"
            else
                # If no arguments were provided, simply execute the script without any arguments
                echo "Running script: $script_path"
                "$interpreter" "$script_path"
            fi

            # Exit the menu script after executing the user script
            exit 0
        fi

        ;;
    esac
}
# Function to perform actions for fun zone options
perform_action_fun_zone() {
    case ${fun_zone_options[selected_index]} in
    "Joker Bomb")
        perform_joker_bomb
        ;;
    "Matrix")
        perform_matrix
        ;;
    "Clock")
        perform_clock
        ;;
    "Tetris")
        bash scripts/tetris.sh
        ;;
    "Weather Man")
        perform_weather
        ;;
    "ASCII STAR WARS")
        clear
        telnet towel.blinkenlights.nl
        ;;
    "Install Tools")
        install_tools
        ;;
    "Back")
        enter_submenu
        ;;
    esac
}
# Function to perform actions for saved results options
perform_action_saved_results() {
    case ${saved_results_options[selected_index]} in
    "Back")
        enter_submenu
        ;;
    "Delete All")
        read -p "Do you want to delete all the results? (y/n): " del_all
        if [[ $del_all =~ ^[Yy]$ ]]; then
            read -p "Last Chance to back out! (y/n): " del_all2
            if [[ $del_all2 =~ ^[Yy]$ ]]; then
                rm -f "$saved_results_directory"/*
                echo "All results have been removed!"
                current_menu="main"
                selected_index=0
                menu_box="   Main Menu"
            else
                echo "Operation cancelled. Results not removed."
            fi
        else
            echo "Operation cancelled. Results not removed."
        fi
        ;;
    "Command Logs")

        results=$(display_logs)
        info_box="${START} ${RED}Select saved results to view${NC} ${END}"
        results
        ;;

    *)
        # Calculate the adjusted index based on the current page
        adjusted_index=$((selected_index + page_index * 5))
        selected_results="${saved_results_options_all[adjusted_index]}"
        if [ -n "$selected_results" ]; then
            results=$(cat "$saved_results_directory/$selected_results" | tr -s ' ' | tr '\t' '     ' | tr -s '\t' | tr -d '\r' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g; s/\x1B\[[0-9]{1,2}A//g; s/\x1B\[0K//g;")

            if [ -n "$results" ]; then
                # Call the results function to display the content
                results
            fi
            info_box="${START} ${RED}Select saved results to view${NC} ${END}"
        fi
        ;;
    esac
}
############################## End Menu Functions
##############################  Begin Nmap Scans
# Function to perform basic Nmap scan
perform_nmap_basic_scan() {
    desc="This will perform a standard nmap scan.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter the IP/Domain to scan: " target
    # Execute the command and store its output
    results=$(nmap "$target")
    previous_command="nmap $target"
    # Log the command along with the IP address
    log_action "$previous_command"
    results

}
# Function to perform total Nmap scan
perform_total_nmap_scan() {
    results=""
    desc="This will perform a full Nmap scan. It uses high verbosity, shows reason for the port state, and performs an OS discovery, version detection, and service detection. This will take some time.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter the IP/Domain to scan: " target
    results=$(nmap -vvvv --reason -T4 -sS -A -sV --version-intensity 9 --version-all -sC -O --osscan-guess "$target")
    previous_command="nmap -vvvv --reason -T4 -sS -A -sV --version-intensity 9 --version-all -sC -O --osscan-guess $target"
    log_action "$previous_command"
    results
}
# Function to perform fast Nmap scan
perform_nmap_fast_scan() {
    results=""
    desc="Fast scan of top 100 ports. Keep in mind that while fast scans are quicker, they may miss less common ports where services could be running. It's often used for initial reconnaissance or when speed is critical, but a comprehensive scan with the full range of ports may still be necessary for thorough security assessments.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter the IP/Domain to scan: " target
    results=$(nmap -F "$target")
    previous_command="nmap -F $target"
    log_action "$previous_command"
    results
}
# Function to perform TCP Nmap scan
perform_nmap_tcp_scan() {
    results=""
    desc="TCP connect scans establish a full three-way TCP handshake, making them more detectable than other scan types. Additionally, some systems may log connection attempts, so use this scan cautiously, especially on networks where you don't have explicit permission to scan.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter the IP/Domain to scan: " target
    results=$(nmap -sT "$target")
    previous_command="nmap -sT $target"
    log_action "$previous_command"
    results
}
# Function to perform TCP ACK Nmap scan
perform_nmap_tcp_ack_scan() {
    results=""
    desc="TCP ACK scans are more stealthy than other types of scans since they do not complete the full TCP handshake. However, they may not work against all types of firewalls and may be less reliable in some network environments.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter the IP/Domain to scan: " target
    results=$(nmap -sA "$target")
    previous_command="nmap -sA $target"
    log_action "$previous_command"
    results
}
# Function to perform UDP Nmap scan
perform_nmap_udp_scan() {
    results=""
    desc="UDP scanning can be slower and less reliable than TCP scanning, as UDP does not provide the same level of confirmation of packet delivery. Additionally, some UDP services might not respond to scanning requests, making it difficult to detect them.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter the IP/Domain to scan: " target
    results=$(nmap -sU "$target")
    previous_command="nmap -sU $target"
    log_action "$previous_command"
    results
}
# Function to perform active host Nmap scan
perform_nmap_active_host_scan() {
    results=""
    desc="The active host scan sends ICMP echo requests (pings) to the target hosts and listens for ICMP responses. If a host responds to the ICMP echo request, it's considered online. This type of scan is useful for quickly identifying active hosts on a network without performing a full port scan.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter the IP/Domain to scan: " target
    results=$(nmap -sn "$target")
    previous_command="nmap -sn $target"
    log_action "$previous_command"
    results
}
# Function to perform protocol Nmap scan
perform_nmap_ip_protocol_scan() {
    results=""
    desc="The IP protocol scan sends IP packets with various IP protocol numbers set in the IP header and listens for responses. The responses indicate which IP protocols are supported by the target system. This scan type may not always be reliable, as some systems may not respond accurately to protocol scan requests. Additionally, some firewalls and network security devices may block or filter certain protocol scan packets.
    
    --FYI:Sometimes this fails and breaks your shell.--
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter the IP/Domain to scan: " target
    results=$(nmap -sO "$target")
    previous_command="nmap -sO $target"
    log_action "$previous_command"
    results
}
# Function to perform stealth Nmap scan
perform_nmap_stealth_scan() {
    results=""
    desc="Initiates a TCP SYN scan, also known as a stealth scan, which sends SYN packets to target ports to determine their state without completing the full TCP handshake.  Sets the timing template to \"Paranoid\", which slows down the scan to use very conservative timing settings, reducing the likelihood of detection by intrusion detection systems or causing network congestion. 
    This is very slow!
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter the IP/Domain to scan: " target
    results=$(nmap -T1 -sS "$target")
    previous_command="nmap -T1 -sS $target"
    log_action "$previous_command"
    results
}
# Function to perform Nmap scan with spoofing
perform_nmap_spoofing_scan() {
    results=""
    desc="This option allows you to specify a random MAC/IP address to use for the packets sent during the scan. However, please note that MAC/IP address spoofing can be considered unethical or illegal in certain contexts, such as when used to bypass network security measures or impersonate devices on a network. It's important to use this feature responsibly and only in controlled, ethical environments where you have explicit permission to do so.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter 'mac' for MAC address spoofing or 'ip' for IP spoofing: " spoof_type

    if [ "$spoof_type" == "mac" ]; then
        echo "This uses a random MAC Address (doesn't work occasionally)"
        read -p "Enter the IP/Domain to scan: " target
        results=$(nmap --spoof-mac 0 "$target")
        previous_command="nmap --spoof-mac 0 $target"
    elif [ "$spoof_type" == "ip" ]; then
        echo "This uses a list of 10 random decoy IPs"
        read -p "Enter the IP/Domain to scan: " target
        results=$(nmap -D RND:10 "$target")
        previous_command="nmap -D RND:10 $target"

    else
        echo "Invalid choice. Please enter 'mac' or 'ip'."
        perform_nmap_spoofing_scan
        return
    fi
    log_action "$previous_command"
    results
}
# Function to perform HTTP site map generator
perform_http_site_map_generator() {
    results=""
    desc="This command will scan port 80 of the specified target and run the HTTP Sitemap Generator script against it, generating a sitemap of the web server's pages.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter the IP/Domain to scan: " target
    results=$(nmap -p80 --script=http-sitemap-generator "$target")
    previous_command="nmap -p80 --script=http-sitemap-generator $target"
    log_action "$previous_command"
    results
}
# Function to perform aggressive Nmap scan
perform_nmap_aggressive_scan() {
    results=""
    desc="This command will scan all 65535 TCP ports on the target system, using aggressive scanning options for thorough reconnaissance. Make sure you have proper authorization before conducting such an intensive scan, as it may cause network disruptions or trigger security alerts.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter the IP/Domain to scan: " target
    results=$(nmap -T4 -A -p- "$target")
    previous_command="nmap -T4 -A -p- $target"
    log_action "$previous_command"
    results
}
# Function to perform fPing
perform_fPing() {
    results=""
    desc="fping is a network diagnostic tool used to send Internet Control Message Protocol (ICMP) echo request packets (ping) to a host to determine whether it's reachable across an IP network. It operates in a similar way to the standard ping utility but offers some additional features and flexibility.
    One of the key features of fping is its ability to send multiple ICMP echo requests in parallel, making it faster than traditional ping for checking the status of multiple hosts simultaneously. This can be particularly useful for network administrators or system administrators who need to quickly assess the reachability of multiple hosts on a network.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "fping"

    read -p "Enter the full IP address to scan the subnet: (e.g. 123.45.67.89): " target
    # Extract first three octets
    subnet=$(echo "$target" | cut -d. -f1-3)

    # Append 0/24 to scan the entire subnet
    subnet="${subnet}.0/24"

    # Execute fping command
    results=$(fping -a -g -q "$subnet")
    previous_command="fping -a -g -q $subnet"
    log_action "$previous_command"
    results
}
# Function to perform service version detection
perform_nmap_service_version_detection() {
    results=""
    desc="This command will perform a service version detection scan on the target system, attempting to determine the versions of services running on open ports.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter the IP address to scan: " target
    results=$(nmap -sV -T4 "$target")
    previous_command="nmap -sV -T4 $target"
    log_action "$previous_command"
    results
}
# function to perform nmap xss scan
perform_nmap_xss_scan() {
    results=""
    desc="This command will perform an XSS scan on the target system, attempting to identify possible cross-site scripting vulnerabilities in the web server.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter the IP address to scan: " target
    results=$(nmap -sV --script=http-stored-xss "$target")
    previous_command="nmap -sV --script=http-stored-xss $target"
    log_action "$previous_command"
    results
}
# function to perform nmap sql scan
perform_nmap_sql_scan() {
    results=""
    desc="This command will perform an SQL injection scan on the target system, attempting to identify possible SQL injection vulnerabilities in the web server.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nmap"
    read -p "Enter the IP address to scan: " target
    results=$(nmap -sV --script=http-sql-injection "$target")
    previous_command="nmap -sV --script=http-sql-injection $target"
    log_action "$previous_command"
    results
}
##############################  end nmap scans
############################## Enumeration Menu
# enum_web menu
# function to perform gobuster
perform_gobuster() {
    results=""
    desc="Gobuster is a versatile and powerful tool for web server enumeration and reconnaissance, helping security professionals identify hidden directories, files, and other resources that may pose security risks. However, it's important to use Gobuster responsibly and ethically, ensuring proper authorization and consent before conducting any brute-forcing activities.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "gobuster"
    # Read mode type
    read -p "Please select a mode type [1] dir, [2] DNS, [3] vhost: " mode
    if [ "$mode" = "1" ]; then
        mode="dir"
        read -p "Enter the target URL: (e.g. http://www.example.com): " target
        read -p "Enter the target port ( default = 80 ): " port
        if [ -z "$port" ]; then
            target="$target"
        else
            target="$target:$port"
        fi
        # Read wordlist path
        read -p "Enter the wordlist path (e.g. /usr/share/wordlists/seclists/Discovery/Web-Content/combined_directories.txt)[Enter for default]: " wordlist
        if [ -z "$wordlist" ]; then
            wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/combined_directories.txt"
        else
            wordlist="$wordlist"

        fi
        # Read file extensions option
        read -p "Scan for File extensions (y/n): " ext
        if [ "$ext" = "y" ] || [ "$ext" = "Y" ]; then
            read -p "Enter the file extension (e.g. .php, .txt, .html): " ext2
            ext="-x $ext2"
        else
            ext=""
        fi
        results=$(gobuster "$mode" -u "$target" -w "$wordlist" "$ext" -t 50 --no-color)
        previous_command="gobuster $mode -u $target -w $wordlist $ext -t 50 --no-color"

    elif [ "$mode" = "2" ]; then
        mode="dns"
        read -p "Enter the target Domain: (e.g. example.com): " target
        read -p "Enter the target port ( default = 80 ): " port
        if [ -z "$port" ]; then
            target="$target"
        else
            target="$target:$port"
        fi
        # Read wordlist path
        read -p "Enter the wordlist path (e.g. /usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt)[Enter for default]: " wordlist
        if [ -z "$wordlist" ]; then
            wordlist="/usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt"
        else
            wordlist="$wordlist"

        fi
        results=$(gobuster "$mode" -r 8.8.8.8 -d "$target" -w "$wordlist" -c -t 50 --no-color)
        previous_command="gobuster $mode -r 8.8.8.8 -d $target -w $wordlist -c -t 50 --no-color"

    elif [ "$mode" = "3" ]; then
        mode="vhost"
        read -p "Enter the target URL: (e.g. http://www.example.com): " target
        read -p "Enter the target port ( default = 80 ): " port
        if [ -z "$port" ]; then
            target="$target"
        else
            target="$target:$port"
        fi
        # Read wordlist path
        read -p "Enter the wordlist path (e.g. /usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt)[Enter for default]: " wordlist
        if [ -z "$wordlist" ]; then
            wordlist="/usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt"
        else
            wordlist="$wordlist"

        fi
        results=$(gobuster "$mode" -u "$target" -t 50 -w "$wordlist" -r --append-domain --no-error --no-color)
        previous_command="gobuster $mode -u $target -t 50 -w $wordlist -r --append-domain --no-error --no-color"

    else
        echo "Invalid mode type. Exiting."
        return
    fi
    log_action "$previous_command"
    results
}

# Function to perform dirb scan
perform_dirb() {
    results=""
    desc="Dirb is a lightweight and efficient tool for web server enumeration and reconnaissance, suitable for users who prefer command-line interfaces for conducting security assessments. However, like other brute-forcing tools, it's important to use Dirb responsibly and ethically, ensuring proper authorization and consent before conducting any brute-forcing activities.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "dirb"
    read -p "Enter the target URL: (e.g. http/s://www.example.com): " target
    read -p "Enter the port to use (Enter for default: 80): " port
    if [ -z "$port" ]; then
        target="$target"
    else
        target="$target:$port"
    fi

    read -p "Enter the wordlist path (e.g. /usr/share/wordlists/seclists/Discovery/Web-Content/combined_directories.txt)[Enter for default]: " wordlist
    if [ -z "$wordlist" ]; then
        wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/combined_directories.txt"
    else
        wordlist="$wordlist"

    fi
    read -p "Any cookies to use? (e.g. sessionid=12345) (y/n): " cookie
    if [ "$cookie" = "y" ] || [ "$cookie" = "Y" ]; then
        if [ -z "$cookie" ]; then
            read -p "Enter the cookie (e.g. sessionid=12345): " cookie2
            cookie="-c $cookie2"
        fi
    fi
    read -p "Authorization? (e.g. username:password) (y/n): " auth
    if [ "$auth" = "y" ] || [ "$auth" = "Y" ]; then
        if [ -z "$auth" ]; then
            read -p "Enter the authorization (e.g. username:password): " auth2
            auth="-u $auth2"
        fi
    fi
    results=$(dirb "$target" "$wordlist" -N 302 "$auth" "$cookie")
    previous_command="dirb $target $wordlist -i -N 302 $auth $cookie"
    log_action "$previous_command"

    results

}
# Function to perform ffuf
perform_ffuf() {
    results=""
    desc="FFUF (Fuzz Faster U Fool) is widely used in penetration testing, bug bounty hunting, and security assessments to identify security weaknesses and vulnerabilities in web applications and servers. It's a flexible and efficient tool that can be adapted to various testing scenarios, making it a valuable asset for security professionals. However, it's important to use FFUF responsibly and ethically, ensuring proper authorization and consent before conducting any fuzzing activities.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "ffuf"
    # Read mode type
    read -p "Please select a mode type [1] Directory/File, [2] sub domain, [3] GET parameters: " mode
    if [ "$mode" = "1" ]; then
        read -p "Enter the target URL for fuzzing: (e.g. http://www.example.com): " target
        read -p "Enter the port to use (Enter for default: 80): " port
        if [ -z "$port" ]; then
            target="$target/FUZZ"
        else
            target="$target:$port/FUZZ"
        fi

        # Read wordlist path
        read -p "Enter the type of fuzz to perform (e.g. [1] directory, [2] file): " type
        if [ "$type" = "1" ]; then
            read -p "Enter path to wordlist (default = /usr/share/wordlists/seclists/Discovery/Web-Content/combined_directories.txt): " wordlist
            if [ -z "$wordlist" ]; then
                wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/combined_directories.txt"
            else
                wordlist="$wordlist"
            fi
        else
            read -p "Enter path to wordlist (default = /usr/share/wordlists/seclists/Discovery/Web-Content/raft_large_files.txt): " wordlist
            if [ -z "$wordlist" ]; then
                wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/raft_large_files.txt"
            else
                wordlist="$wordlist"
            fi
        fi
        # Read file extensions option
        read -p "Scan for File extensions (y/n): " ext
        if [ "$ext" = "y" ] || [ "$ext" = "Y" ]; then
            read -p "Enter the file extension (e.g. .php,.txt,.html): " ext2
            ext="$ext2"
        fi
        read -p "Any cookies to use (e.g. sessionid=12345) (y/n): " cookie
        if [ "$cookie" = "y" ] || [ "$cookie" = "Y" ]; then
            if [ -z "$cookie" ]; then
                read -p "Enter the cookie (e.g. sessionid=12345): " cookie2
                cookie="$cookie2"
            fi
        fi
        results=$(ffuf -u "$target" -w "$wordlist" -e "$ext" -s "$cookie" -t 50 -ac -mc all)
        previous_command="ffuf -u $target -w $wordlist $ext $cookie -mc 200 -ac -t 50"

    elif [ "$mode" = "2" ]; then
        read -p "Enter the target Base URL for subdomain fuzzing: (e.g. http://example.com): " target
        read -p "Enter the port to use (Enter for default: 80): " port
        if [ -z "$port" ]; then
            target="FUZZ.target"
        else
            target="FUZZ.$target:$port"
        fi
        # Read wordlist path
        read -p "Enter the wordlist path (e.g. /usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt)[Enter for default]: " wordlist
        if [ -z "$wordlist" ]; then
            wordlist="/usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt"
        else
            wordlist="$wordlist"
        fi
        results=$(ffuf -u "$target" -w "$wordlist" -mc 200 -ac -t 50)
        previous_command="ffuf -u $target -w $wordlist -mc 200 -ac -t 50)"

    elif [ "$mode" = "3" ]; then
        read -p "Enter the target URL for parameter fuzzing: (e.g. http://www.example.com): " target
        read -p "Enter GET parameters (e.g. FUZZ=value1 or param1=FUZZ): " params
        read -p "Enter the port to use (Enter for default: 80): " port
        if [ -z "$port" ]; then
            target="$target/$params"
        else
            target="$target:$port/$params"
        fi
        # Read wordlist path
        read -p "Enter fuzzing type (e.g. [1] FUZZ=value1 or [2] param1=FUZZ): " wordlist
        if [ "$wordlist" = "1" ]; then
            echo "Using seclists burp-parameter-names wordlist"
            wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/burp-parameter-names.txt"
        elif [ "$wordlist" = "2" ]; then
            echo " Using seclists combined_words wordlist"
            wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/combined_words.txt"
        fi
        results=$(ffuf -u "$target" -w "$wordlist" -mc 200 -ac -t 50)
        previous_command="ffuf -u $target -w $wordlist -mc 200 -ac -t 50"

    else
        echo "Invalid mode type. Exiting."
        return
    fi
    log_action "$previous_command"
    results
}
# function to perform wfuzz
perform_wfuzz() {
    results=""
    desc="WFuzz is a versatile tool that's widely used in the cybersecurity community for identifying vulnerabilities in web applications and assessing their security posture. It requires a solid understanding of web security concepts and ethical hacking practices to be used effectively.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "wfuzz"
    read -p "Select a mode [1] Directory/File fuzzing, [2] Subdomain fuzzing [3] GET Parameter fuzzing [4] Injection fuzzing: " mode
    if [ "$mode" = "1" ]; then
        read -p "Enter the target URL for fuzzing: (e.g. http://www.example.com): " target
        read -p "Enter the port to use (Enter for default: 80): " port
        if [ -z "$port" ]; then
            target="$target/FUZZ"
        else
            target="$target:$port/FUZZ"
        fi
        read -p "Enter the type of fuzz to perform (e.g. [1] directory, [2] file): " type
        if [ "$type" = "1" ]; then
            read -p "Enter path to Directory wordlist (default = /usr/share/wordlists/seclists/Discovery/Web-Content/combined_directories.txt): " wordlist
            if [ -z "$wordlist" ]; then
                wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/combined_directories.txt"
            else
                wordlist="$wordlist"
            fi
        else
            read -p "Enter path to File name wordlist (default = /usr/share/wordlists/seclists/Discovery/Web-Content/raft_large_files.txt): " wordlist
            if [ -z "$wordlist" ]; then
                wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/raft_large_files.txt"
            else
                wordlist="$wordlist"
            fi
        fi

        read -p "Select HTTP response codes to show (default = 200 or 200,301,401 etc..): " code
        if [ -z "$code" ]; then
            code="200"
        else
            code="$code"
        fi

        results=$(wfuzz -w "$wordlist" --sc "$code" -u "$target" &)
        previous_command="wfuzz -w $wordlist --sc $code -u $target"

    elif [ "$mode" = "2" ]; then
        read -p "Enter the target Base URL for fuzzing: (e.g. http://example.com): " target
        read -p "Enter the port to use (Enter for default: 80): " port
        if [ -z "$port" ]; then
            target="FUZZ.$target"
        else
            target="FUZZ.$target:$port"
        fi
        read -p "Enter path to wordlist (default = /usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt): " wordlist
        if [ -z "$wordlist" ]; then
            wordlist="/usr/share/wordlists/seclists/Discovery/DNS/combined_subdomains.txt"
        else
            wordlist="$wordlist"
        fi
        read -p "Select HTTP response codes to show (default = 200 or 200,301,401 etc..): " code
        if [ -z "$code" ]; then
            code="200"
        else
            code="$code"
        fi

        results=$(wfuzz -w "$wordlist" --sc "$code" -u "$target")
        previous_command="wfuzz -w $wordlist --sc $code -u $target"

    elif [ "$mode" = "3" ]; then
        read -p "Enter the target URL for parameter fuzzing: (e.g. http://www.example.com): " target
        read -p "Enter GET parameters (e.g. FUZZ=value1 or param1=FUZZ): " params
        read -p "Enter the port to use (Enter for default: 80): " port
        if [ -z "$port" ]; then
            target="$target/$params"
        else
            target="$target:$port/$params"
        fi
        read -p "Enter fuzzing type (e.g. [1] FUZZ=value1 or [2] param1=FUZZ): " wordlist
        if [ "$wordlist" = "1" ]; then
            echo "Using seclists burp-parameter-names wordlist"
            wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/burp-parameter-names.txt"
        elif [ "$wordlist" = "2" ]; then
            echo "Using seclists combined_words wordlist"
            wordlist="/usr/share/wordlists/seclists/Discovery/Web-Content/combined_words.txt"
        fi
        read -p "Select HTTP response codes to show (default = 200 or 200,301,401 etc..): " code
        if [ -z "$code" ]; then
            code="200"
        else
            code="$code"
        fi

        results=$(wfuzz -w "$wordlist" --sc "$code" -u "$target")
        previous_command="wfuzz -w $wordlist --sc $code -u $target"

    elif [ "$mode" = "4" ]; then
        read -p "Enter the target URL for parameter fuzzing: (e.g. http://www.example.com): " target
        read -p "Enter GET parameters (e.g. param1=FUZZ): " params
        read -p "Enter the port to use (Enter for default: 80): " port
        if [ -z "$port" ]; then
            target="$target/$params"
        else
            target="$target:$port/$params"
        fi
        read -p "Enter injection type (e.g. [1] SQL [2] XSS [3] LFI): " wordlist
        if [ "$wordlist" = "1" ]; then
            wordlist="/usr/share/wordlists/seclists/Fuzzing/SQLi/Generic-SQLi.txt"
        elif [ "$wordlist" = "2" ]; then
            wordlist="/usr/share/wordlists/seclists/Fuzzing/XSS/human-friendly/XSS-Cheat-Sheet-PortSwigger.txt"
        elif [ "$wordlist" = "3" ]; then
            wordlist="/usr/share/wordlists/seclists/Fuzzing/LFI/LFI-LFISuite-pathtotest-huge.txt"
        fi
        read -p "Select HTTP response codes to show (default = 200 or 200,301,401 etc..): " code
        if [ -z "$code" ]; then
            code="200"
        else
            code="$code"
        fi
        results=$(wfuzz -w "$wordlist" --sc "$code" -u "$target")
        previous_command="wfuzz -w $wordlist --sc $code -u $target"

    fi

    log_action "$previous_command"

    results

}
############################ end enum_web
# enum_dns menu
# Function to perform dig
perform_dig() {
    results=""
    desc="Dig stands for (domain information groper.) It is a command-line tool used for querying DNS (Domain Name System) servers. dig is commonly available on Unix-like operating systems such as Linux and macOS. It provides a flexible and powerful interface for querying DNS servers and retrieving information about domain names, IP addresses, and various DNS records.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "dig"
    # Execute dig command
    # Read mode type
    read -p "Please select a mode type [1] Domain to IP, [2] Nameserver, [3] eMail Exchange, [4] Reverse IP Lookup, [5] TXT annotation, [6]  All Information, [7] My public IP: " mode
    if [ "$mode" = "1" ]; then
        read -p "Enter the target domain: " target
        results=$(dig "$target")
        previous_command="dig $target"

    elif [ "$mode" = "2" ]; then
        read -p "Enter the target domain: " target
        results=$(dig +ns "$target")
        previous_command="dig +ns $target"

    elif [ "$mode" = "3" ]; then
        read -p "Enter the target domain: " target
        results=$(dig MX "$target")
        previous_command="dig MX $target"

    elif [ "$mode" = "4" ]; then
        read -p "Enter the target IP: " target
        results=$(dig -x "$target")
        previous_command="dig -x $target"

    elif [ "$mode" = "5" ]; then
        read -p "Enter the target domain: " target
        results=$(dig txt "$target")
        previous_command="dig txt $target"

    elif [ "$mode" = "6" ]; then
        read -p "Enter the target domain: " target
        results=$(dig +noall +answer "$target")
        previous_command="dig +noall +answer $target"

    elif [ "$mode" = "7" ]; then
        results=$(dig +short myip.opendns.com @resolver1.opendns.com)
        previous_command="dig +short myip.opendns.com @resolver1.opendns.com"

    else
        echo "Invalid mode type. Exiting."
        return

    fi
    log_action "$previous_command"
    results
}
# Perform DNSenum
perform_dns_enum() {
    results=""
    desc="DNSenum is a tool used in information gathering during the reconnaissance phase of penetration testing. It's designed to gather information about a target domain by querying DNS (Domain Name System) servers. DNSenum can discover subdomains, DNS records, and perform zone transfers, which can provide valuable information to an attacker or security professional about the target's network infrastructure. It's often used to identify potential points of entry or vulnerabilities in a system's DNS configuration.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "dnsenum"
    # Read target
    read -p "Enter the target domain: " target

    # Execute dnsenum command
    results=$(dnsenum "$target")
    previous_command="dnsenum $target"
    log_action "$previous_command"
    results
}
# Perform DNSrecon
perform_dns_recon() {
    results=""
    desc="DNSRecon is a powerful DNS reconnaissance tool used for enumerating DNS information about a domain. It's commonly used during the information gathering phase of penetration testing or in security assessments to gather intelligence about a target's DNS infrastructure. DNSRecon can perform various types of DNS queries to discover subdomains, enumerate DNS records, perform zone transfers, and identify potential DNS misconfigurations or vulnerabilities.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "dnsrecon"
    read -p "Please select a mode type [1] General Enum, [2] Zone Transfer, [3] Zone Walk, [4] SubDomain/Host Bing Search, [5] SubDomain/Host Yandex Search, [6] DNS Brute Force: " mode
    if [ "$mode" = "1" ]; then
        read -p "Enter the target domain: " target
        results=$(dnsrecon -d "$target")
        previous_command="dnsrecon -d $target"

    elif [ "$mode" = "2" ]; then
        read -p "Enter the target domain: " target
        results=$(dnsrecon -d "$target" -t axfr)
        previous_command="dnsrecon -d $target -t axfr"
    elif [ "$mode" = "3" ]; then
        read -p "Enter the target domain: " target
        results=$(dnsrecon -d "$target" -z)
        previous_command="dnsrecon -d $target -z"
    elif [ "$mode" = "4" ]; then
        read -p "Enter the target domain: " target
        results=$(dnsrecon -d "$target" -b)
        previous_command="dnsrecon -d $target -b"
    elif [ "$mode" = "5" ]; then
        read -p "Enter the target domain: " target
        results=$(dnsrecon -d "$target" -y)
        previous_command="dnsrecon -d $target -y"
    elif [ "$mode" = "6" ]; then
        echo "This will take some time!"
        read -p "Enter the target domain: " target
        read -p "Enter the wordlist path (default: /usr/share/wordlists/amass/all.txt) enter for default: " wordlist
        if [ -z "$wordlist" ]; then
            wordlist="/usr/share/wordlists/amass/all.txt"
        else
            wordlist="$wordlist"

        fi
        results=$(dnsrecon -d "$target" -t brt -D "$wordlist")
        previous_command="dnsrecon -d $target -t brt -D $wordlist"

    else
        echo "Invalid mode type. Exiting."
        return

    fi
    log_action "$previous_command"
    results
}
# Perform DNSmap
perform_dns_map() {
    results=""
    desc="DNSmap is a passive DNS network mapper used to discover subdomains and information about DNS servers. It works by analyzing DNS records passively, meaning it does not send any DNS queries directly to DNS servers but rather gathers information from network traffic or DNS cache dumps. DNSmap can be used for reconnaissance and information gathering during penetration testing or security assessments to discover subdomains of a target domain and to enumerate DNS records. By analyzing DNS records, it can provide valuable information about the target's network infrastructure and potentially reveal hidden or undocumented subdomains that could be used in attacks.
    THIS MAY TAKE A WHILE!!
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "dnsmap"
    read -p "Enter the target domain: " target
    read -p "[1] for DNSmap builtin wordlist, [2] User supplied wordlist" mode
    if [ "$mode" = "1" ]; then
        results=$(dnsmap -d "$target")
        previous_command="dnsmap -d $target"
    elif [ "$mode" = "2" ]; then
        read -p "Enter the wordlist path (default: /usr/share/wordlists/amass/all.txt) enter for default: " wordlist
        if [ -z "$wordlist" ]; then
            wordlist="/usr/share/wordlists/amass/all.txt"
        else
            wordlist="$wordlist"

        fi
        results=$(dnsmap -d "$target" -w "$wordlist")
        previous_command="dnsmap -d $target -w $wordlist"

    else
        echo "Invalid mode type. Exiting."
        return
    fi
    log_action "$previous_command"
    results

}
# perform theHarvester scan
perform_harvest() {
    results=""
    desc="theHarvester is an open-source reconnaissance tool designed to gather information from public sources about a target, often used in penetration testing, ethical hacking, and cybersecurity research. It is part of the Kali Linux distribution and can also be installed on other operating systems. theHarvester helps gather information such as domain names, subdomains, IP addresses, email addresses, URLs, and other data relevant to a given target.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "harvest"
    read -p "Enter the target: " target
    read -p "Enter the number of results to show: " limit
    desc="anubis, baidu, bevigil(API_key), binaryedge(API_key), bing, bingapi(API_key), bufferoverun(API_key), brave(not working for me), censys(API_key), certspotter, criminalip(API_key), crtsh, dnsdumpster, duckduckgo, fullhunt(API_key), github-code(API_key), hackertarget, hunter(API_key), hunterhow(API_key), intelx(API_key), netlas(API_key), onyphe(API_key), otx, pentesttools(API_key), projectdiscovery(API_key), rapiddns, rocketreach(API_key), securityTrails(API_key), sitedossier(Triggers a captcha use the site sitedossier.com), subdomaincenter, subdomainfinderc99(Never returns any data, use the site https://subdomainfinder.c99.nl/), threatminer(returns IPs), tomba(API_key), urlscan(extra info), virustotal(API_key), yahoo, zoomeye(API_key)
    
    ---If you have an API_key choose the source and enter it, and I will add it for you!---"
    show_description "harvest"
    # List of sources with an API key
    api_key_sources="bevigil(API_key) binaryedge(API_key) bingapi(API_key) bufferoverun(API_key) censys(API_key) criminalip(API_key) fullhunt(API_key) hunter(API_key) pentesttools(API_key) projectdiscovery(API_key) securityTrails(API_key) tomba(API_key) virustotal(API_key)"
    read -p "Enter the source from above to use for the search: " source
    # Check if the source is among those requiring an API key
    if echo "$api_key_sources" | grep -q "\b$source\b"; then
        # Handle specific cases for unique requirements
        case $source in
        "censys")
            # Check if ID and Secret are filled
            id_value=$(sed -n "/^  $source:/,/^  [a-z]/p" /etc/theHarvester/api-keys.yaml | grep -oP "(?<=id: ).*")
            secret_value=$(sed -n "/^  $source:/,/^  [a-z]/p" /etc/theHarvester/api-keys.yaml | grep -oP "(?<=secret: ).*")

            if [ -z "$id_value" ]; then
                read -p "This source requires an ID. Please enter your ID: " id
                sed -i "/^  $source:/,/^  [a-z]/s/id:.*/id: $id/" /etc/theHarvester/api-keys.yaml
            fi

            if [ -z "$secret_value" ]; then
                read -p "Please enter your Secret: " secret
                sed -i "/^  $source:/,/^  [a-z]/s/secret:.*/secret: $secret/" /etc/theHarvester/api-keys.yaml
            fi
            ;;

        "tomba")
            # Check if Key and Secret are filled
            key_value=$(sed -n "/^  $source:/,/^  [a-z]/p" /etc/theHarvester/api-keys.yaml | grep -oP "(?<=key: ).*")
            secret_value=$(sed -n "/^  $source:/,/^  [a-z]/p" /etc/theHarvester/api-keys.yaml | grep -oP "(?<=secret: ).*")

            if [ -z "$key_value" ]; then
                read -p "Please enter your Key: " key
                sed -i "/^  $source:/,/^  [a-z]/s/key:.*/key: $key/" /etc/theHarvester/api-keys.yaml
            fi

            if [ -z "$secret_value" ]; then
                read -p "Please enter your Secret: " secret
                sed -i "/^  $source:/,/^  [a-z]/s/secret:.*/secret: $secret/" /etc/theHarvester/api-keys.yaml
            fi
            ;;

        *)
            # Default case for sources requiring an API key
            key_value=$(sed -n "/^  $source:/,/^  [a-z]/p" /etc/theHarvester/api-keys.yaml | grep -oP "(?<=key: ).*")

            if [ -z "$key_value" ]; then
                read -p "This source requires an API key. Please enter your API key: " key
                sed -i "/^  $source:/,/^  [a-z]/s/key:.*/key: $key/" /etc/theHarvester/api-keys.yaml
            fi
            ;;
        esac
    fi
    results=$(theHarvester -d "$target" -l "$limit" -b "$source")
    previous_command="theHarvester -d $target -l $limit -b $source"
    log_action "$previous_command"
    results

}
############################ End enum_dns
# enum_file menu
# perform dotdotpwn
perform_dotdotpwn() {
    results=""
    desc="dotdotpwn is a popular penetration testing tool used for Directory Traversal attacks, where an attacker attempts to access files and directories outside the web server's root directory. This tool is designed to test web applications for directory traversal vulnerabilities by crafting payloads to navigate through the filesystem.
    
    [5] The Traversal Engine will create fuzz pattern strings with 8 levels of deepth and print the results to STDOUT, so you can use it as you wish, for example, passing the traversal patterns as a parameter to another application, pipe, socket, etc. 
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "dotdotpwn"
    read -p "Select a mode to [1] HTTP/HTTPS, [2] HTTP-URL, [3] FTP,  [4] TFTP, [5] STDOUT " mode
    if [ "$mode" = "1" ]; then
        read -p "Enter the target IP: " target
        read -p "Enter traversal depth. (i.e. 4 = ../../../../): " depth
        read -p "Enter the port: " port
        read -p "File to traverse: (i.e. /etc/hosts): " file
        read -p "Keyword to look for in the file: (i.e. localhost): " keyword
        read -p "Detect Operating System? (y/n): " os
        if [[ $os =~ ^[Yy]$ ]]; then
            results=$(dotdotpwn -m http -h "$target" -x "$port" -f "$file" -k "$keyword" -d "$depth" -t 200 -s -O -q)
            previous_command="dotdotpwn-m http -h $target -x $port -f $file -k \"$keyword\" -d $depth -t 200 -s -O -q"

        elif [[ $os =~ ^[Nn]$ ]]; then
            results=$(dotdotpwn -m http -h "$target" -x "$port" -f "$file" -k "$keyword" -d "$depth" -t 200 -s -q)
            previous_command="dotdotpwn-m http -h $target -x $port -f $file -k \"$keyword\" -d $depth -t 200 -s -q"

        fi
    elif [ "$mode" = "2" ]; then
        read -p "Enter the target URL: (i.e. http://192.168.1.1:10000/unauthenticated/TRAVERSAL ): " target
        read -p "File to traverse: (i.e. /etc/hosts): " file
        read -p "Keyword to look for in the file: (i.e. localhost): " keyword
        read -p "Detect Operating System? (y/n): " os
        if [[ $os =~ ^[Yy]$ ]]; then
            results=$(dotdotpwn -m http-url -h "$target" -O -f "$file" -k "$keyword" -q)
            previous_command="dotdotpwn -m http-url -h $target -O -f $file -k \"$keyword\" -q"

        elif [[ $os =~ ^[Nn]$ ]]; then
            results=$(dotdotpwn -m http-url -h "$target" -f "$file" -k "$keyword" -q)
            previous_command="dotdotpwn -m http-url -h $target -f $file -k \"$keyword\" -q"

        fi
    elif [ "$mode" = "3" ]; then
        read -p "Enter the target IP: " target
        read -p "Enter traversal depth. (i.e. 4 = ../../../../): " depth
        read -p "File to traverse: (i.e. /etc/hosts): " file
        read -p "Keyword to look for in the file: (i.e. localhost): " keyword
        read -p "Enter username for authentication: " user
        read -p "Enter password for authentication: " pass
        read -p "Detect Operating System? (y/n): " os
        read -p "Search for extra files? (y/n):" xtra
        if [[ $xtra =~ ^[Yy]$ ]]; then
            if [[ $os =~ ^[Yy]$ ]]; then
                results=$(dotdotpwn -m ftp -h "$target" -U "$user" -P "$pass" -f "$file" -k "$keyword" -d "$depth" -t 200 -s -O -E)
                previous_command="dotdotpwn -m ftp -h $target -U $user -P $pass -f $file -k \"$keyword\" -d $depth -t 200 -s -O -E"

            elif [[ $os =~ ^[Nn]$ ]]; then
                results=$(dotdotpwn -m ftp -h "$target" -U "$user" -P "$pass" -f "$file" -k "$keyword" -d "$depth" -t 200 -s -E)
                previous_command="dotdotpwn -m ftp -h $target -U $user -P $pass -f $file -k \"$keyword\" -d $depth -t 200 -s -E"

            fi
        elif [[ $xtra =~ ^[Nn]$ ]]; then
            if [[ $os =~ ^[Yy]$ ]]; then
                results=$(dotdotpwn -m ftp -h "$target" -U "$user" -P "$pass" -f "$file" -k "$keyword" -d "$depth" -t 200 -s -O)
                previous_command="dotdotpwn -m ftp -h $target -U $user -P $pass -f $file -k \"$keyword\" -d $depth -t 200 -s -O"

            elif [[ $os =~ ^[Nn]$ ]]; then
                results=$(dotdotpwn -m ftp -h "$target" -U "$user" -P "$pass" -f "$file" -k "$keyword" -d "$depth" -t 200 -s)
                previous_command="dotdotpwn -m ftp -h $target -U $user -P $pass -f $file -k \"$keyword\" -d $depth -t 200 -s"

            fi
        fi
    elif [ "$mode" = "4" ]; then
        read -p "Enter the target domain: " target
        read -p "Enter traversal depth. (i.e. 4 = ../../../../): " depth
        read -p "File to traverse: (i.e. /etc/hosts): " file
        read -p "Keyword to look for in the file: (i.e. localhost): " keyword
        results=$(dotdotpwn -m tftp -h "$target" -f "$file" -k "$keyword" -d "$depth" -t 200 -s -q -O -E)
        previous_command="dotdotpwn -m tftp -h $target -O -f $file -k \"$keyword\" -d $depth -t 200 -s -q -O -E"

    elif [ "$mode" = "5" ]; then
        echo "An example usage of the STDOUT mode could be passed to perl to produce a GET request which is piped to netcat listening on localhost port 10000 (webmin). That POC could look like:
        hacker@yourbox: ~/dotdotpwn $ for fuzz_pattern in \$(dotdotpwn -m stdout -d 5 -f /etc/passwd); do perl -e \" print \"GET /unauthenticated/\$fuzz_pattern HTTP/1.0\r\n\r\n\";\" | nc localhost 10000; done | grep \"root:\""
        read -p "Enter the depth of the traversal to output (i.e. 6 is default)" depth
        results=$(dotdotpwn -m stdout -d "$depth")
        previous_command="dotdotpwn -m stdout -d $depth"

    else
        echo "Invalid mode type. Exiting."
        return
    fi
    log_action "$previous_command"
    results
}
# function to perform SearchSploit

perform_searchsploit() {
    results=""
    desc="SearchSploit is a command-line tool included in the Exploit Database package, which is available on Kali Linux and other security-focused distributions. It allows users to search through the Exploit Database (Exploit-DB) for known vulnerabilities and exploits."
    show_description "searchsploit"

    read -p "Enter the mode to use [1] Search for exploit, [2] View exploit details, [3] Move exploit to home directory, [4] Update SearchSploit Database " mode

    case $mode in
        "1")
            read -p "Enter the exploit term to search for: " target
            results=$(searchsploit "$target" --id)
            previous_command="searchsploit $target --id"
            ;;
        "2")
            read -p "Enter the ID of the exploit to view details: " exploit_id
            if [ -n "$exploit_id" ]; then
                results=$(searchsploit -x "$exploit_id")
                previous_command="searchsploit -x $exploit_id"
            else
                echo "No ID entered. Exiting."
                return
            fi
            ;;
        "3")
            read -p "Enter the ID of the exploit to copy: " exploit_id
            if [ -n "$exploit_path" ]; then
                results=$(searchsploit -m "$exploit_id")
                previous_command="searchsploit -m $exploit_id"
                echo "Exploit copied to current working directory."
            else
                echo "Error occured, Exiting."
                return
            fi
            ;;
        "4")
            read -p "Do you want to update the exploit database? (y/n): " update_choice
            if [ "$update_choice" == "y" ]; then
                echo "Updating the exploit database..."
                searchsploit -u
                echo "Exploit database updated."
            else
                echo "Exploit database not updated."
            fi
            ;;
        "*")
            echo "Invalid mode selected. Exiting."
            return
            ;;
    esac

    log_action "$previous_command"
    results
}

############################ Network tools
#Function to perform ifconfig
perform_ifconfig() {
    view=true
    results=""
    desc="ifconfig (short for interface configuration) is a command-line utility in UNIX-based systems used to configure network interfaces and display information about them.  It can display details about all network interfaces, such as their IP addresses, netmasks, broadcast addresses, MAC addresses, bring network interfaces up or down, effectively enabling or disabling them. It also allows you to set IP addresses and subnet masks or a specific MAC address (also known as a hardware address) to an interface."
    show_description "ifconfig"
    echo "Any key to show (Interface: IPaddress): "
    # shellcheck disable=SC2034
    read -n1 key
    results=$(ifconfig | grep -E '^[a-zA-Z0-9]+:' -A 1 | grep -oP '^[a-zA-Z0-9]+|(?<=inet )[^ ]+' | paste -d' ' - -)
    previous_command="ifconfig | grep -E '^[a-zA-Z0-9]+:' -A 1 | grep -oP '^[a-zA-Z0-9]+|(?<=inet )[^ ]+' | paste -d' ' - -"
    log_action "$previous_command"
    results
    view=false
}
# Function to view or edit/restore host file
perform_hosts() {
    results=""
    desc="The hosts file is a plain text file found in most operating systems that maps hostnames to IP addresses. It is a simple way to override or supplement the Domain Name System (DNS) for local hostname resolution. Location: On UNIX-like systems (such as Linux and macOS), the hosts file is typically located at /etc/hosts.
    
    [2] will allow you to add an entry to your host file OR if one has already been added revert back to the original host file."
    show_description "hosts"
    read -p " [1] Show hosts file, [2] Edit/Restore hosts file: " mode
    if [ "$mode" = "1" ]; then
        view=true
        results=$(cat /etc/hosts)

        results
    elif [ "$mode" = "2" ]; then
        view=false
        if [ -f /etc/hosts.backup_temporary ]; then
            sudo \rm -f /etc/hosts
            sudo \mv /etc/hosts.backup_temporary /etc/hosts
            sudo chmod 644 /etc/hosts
            results=$(cat /etc/hosts)
            results
        else
            read -p "Enter IP address: " ip
            read -p "Enter hostname: " hostname
            # Make a backup of the hosts file
            sudo \mv /etc/hosts /etc/hosts.backup_temporary

            # Create a new hosts file with the specified IP and domain
            sudo bash -c "printf \"#\n# /etc/hosts: static lookup table for host names\n#\n\n127.0.0.1       localhost\n255.255.255.255 broadcasthost\n\n\n# The following lines are desirable for IPv6 capable hosts\n::1             localhost\n::1             ip6-localhost ip6-loopback\nfe00::0         ip6-localnet\nff00::0         ip6-mcastprefix\nff02::1         ip6-allnodes\nff02::2         ip6-allrouters\nff02::3         ip6-allhosts\n$ip    $hostname\n\" >> /etc/hosts"
            results=$(cat /etc/hosts)
            results
        fi
    else
        echo "Invalid selection. Exiting."
        return
    fi

}

# Function to perform geolocation by ip
perform_geo() {
    view=true
    results=""
    desc="Geolocation by IP refers to the process of determining the approximate geographical location of a device or user based on their Internet Protocol (IP) address. This technology is used to derive information about a user's location, including country, region, city, and other details, from the IP address assigned to their device by their Internet Service Provider (ISP)."
    show_description "geo"
    read -p "Enter IP to locate: " ip
    results=$(curl https://api.hackertarget.com/ipgeo/?q=$ip && echo "")
    previous_command="curl https://api.hackertarget.com/ipgeo/?q=$ip"
    log_action "$previous_command"
    results    view=false
}
############################ VulnerabilityMmenu
# Function to perform Nikto scan
perform_nikto_scan() {
    results=""
    desc="Nikto is an open-source web server scanner used to identify potential security vulnerabilities and misconfigurations in web servers and web applications. read more here https://github.com/sullo/nikto/wiki
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "nikto"

    read -p "Enter the Domain/IP address to scan: " target
    read -p "Enter the target port ( default = 80 ): " port
    if [ -z "$port" ]; then
        target="$target"
    else
        target="$target:$port"
    fi
    read -p "Should we use SSl/HTTPS? (y/n): " ssl
    if [[ $ssl =~ ^[Yy]$ ]]; then
        results=$(nikto -h "$target" -ssl)
        previous_command="nikto -h $target -ssl"

    else
        results=$(nikto -h "$target")
        previous_command="nikto -h $target"

    fi
    log_action "$previous_command"
    results
}
# Function to perform SQLmap scan
perform_sqlmap_scan() {
    results=""
    # display_menu
    desc="SQLMap is an open source penetration testing tool that automates the process of detecting and exploiting SQL injection flaws and taking over of database servers. It comes with a powerful detection engine, many niche features for the ultimate penetration tester, and a broad range of switches including database fingerprinting, over data fetching from the database, accessing the underlying file system, and executing commands on the operating system via out-of-band connections.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "sqlmap"
    read -p "Enter the target URL to scan: (e.g. http://www.site.com/vuln.php?id=1): " target
    read -p "Enter the target port ( default = 80 ): " port
    if [ -z "$port" ]; then
        target="$target"
    else
        target="$target:$port"
    fi
    read -p "Does this need to be authenticated? (y/n): " auth
    read -p "Does this request need a cookie? (y/n): " cookie

    if [[ $auth =~ ^[Yy]$ ]] && [[ $cookie =~ ^[Yy]$ ]]; then
        read -p "Enter the username: " username
        read -p "Enter the password: " password
        read -p "Enter cookie data: " cookie_data
        sqlmap -u "$target" --auth-type Basic --auth-cred "$username:$password" --cookie="$cookie_data" -v 6 --random-agent --risk=3 -a

    elif [[ $auth =~ ^[Yy]$ ]]; then
        read -p "Enter the username: " username
        read -p "Enter the password: " password
        sqlmap -u "$target" --auth-type Basic --auth-cred "$username:$password" -v 6 --random-agent --risk=3 -a

    elif [[ $cookie =~ ^[Yy]$ ]]; then
        read -p "Enter cookie data: " cookie_data
        sqlmap -u "$target" --cookie="$cookie_data" -v 6 --random-agent --risk=3 -a
    else
        sqlmap -u "$target" --risk=3 -v 6 --random-agent -a

    fi

}
# Function to perform WPScan
perform_wpscan() {
    results=""
    desc="WPScan is a security scanner specifically designed for WordPress websites. It is an open-source tool used by security professionals, administrators, and developers to detect vulnerabilities within WordPress installations, themes, and plugins. WPScan can help identify potential security risks and misconfigurations, enabling website owners to take proactive steps to secure their sites.
    
    --For detailed vulnerability information, WPScan requires an API token. Register at https://wpscan.com/pricing/ and obtain a token.--
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "wpscan"
    read -p "Enter the target URL to scan: (e.g http/s://www.example.com): " target
    read -p "Select the type of scan: [1] Basic, [2] Enumeration, [3] Brute force [4] Vulnerability (reuires an API_Key): " mode

    if [[ $mode == 1 ]]; then
        results=$(wpscan --url "$target")
        previous_command="wpscan --url $target"

    elif [[ $mode == 2 ]]; then
        read -p "Enumerate [1] Plugins, [2] Themes, [3] Users, [4] Config backups, [5] DB exports, [6] All: " enum
        if [[ $enum == 1 ]]; then
            results=$(wpscan --url "$target" --enumerate ap --random-user-agent)
            previous_command="wpscan --url $target --enumerate ap --random-user-agent"
        elif [[ $enum == 2 ]]; then
            results=$(wpscan --url "$target" --enumerate at --random-user-agent)
            previous_command="wpscan --url $target --enumerate at --random-user-agent"
        elif [[ $enum == 3 ]]; then
            results=$(wpscan --url "$target" --enumerate u --random-user-agent)
            previous_command="wpscan --url $target --enumerate u --random-user-agent"
        elif [[ $enum == 4 ]]; then
            results=$(wpscan --url "$target" --enumerate cb --random-user-agent)
            previous_command="wpscan --url $target --enumerate cb --random-user-agent"
        elif [[ $enum == 5 ]]; then
            results=$(wpscan --url "$target" --enumerate dbe --random-user-agent)
            previous_command="wpscan --url $target --enumerate dbe --random-user-agent"
        elif [[ $enum == 6 ]]; then
            results=$(wpscan --url "$target" --enumerate ap,at,u --random-user-agent)
            previous_command="wpscan --url $target --enumerate ap,at,u,cb,dbe --random-user-agent"
        fi

    elif [[ $mode == 3 ]]; then
        read -p "Enter Username/Username file: (e.g user user1,user2 /tmp/user.txt) " user
        read -p "Enter Password file: " pass
        results=$(wpscan --url "$target" --usernames "$user" --passwords "$pass" --random-user-agent)
        previous_command="wpscan --url $target --usernames $user --passwords $pass --random-user-agent"

    elif [[ $mode == 4 ]]; then
        read -p "Enter API_key: " key
        read -p "Enumerate Vulnerable [1] Plugins, [2] Themes, [3] TimThumbs [4] All: " enum
        if [[ $enum == 1 ]]; then
            results=$(wpscan --url "$target" --enumerate vp --api-token "$key" --random-user-agent)
            previous_command="wpscan --url $target --enumerate vp --random-user-agent"
        elif [[ $enum == 2 ]]; then
            results=$(wpscan --url "$target" --enumerate vt --api-token "$key" --random-user-agent)
            previous_command="wpscan --url $target --enumerate vt --random-user-agent"
        elif [[ $enum == 3 ]]; then
            results=$(wpscan --url "$target" --enumerate tt --api-token "$key" --random-user-agent)
            previous_command="wpscan --url $target --enumerate tt --random-user-agent"
        elif [[ $enum == 4 ]]; then
            results=$(wpscan --url "$target" --enumerate vp,vt,tt --api-token "$key" --random-user-agent)
            previous_command="wpscan --url $target --enumerate vp,vt,tt --random-user-agent"
        fi
    fi
    log_action "previous_command"
    results
}

############################ end Vulnerability Menu

############################ Password Menu
# Function to perform John the Ripper password cracking
perform_john_the_ripper() {
    results=""
    desc="John the Ripper (JtR) is an open-source password-cracking tool. It is commonly used by security professionals, penetration testers, and system administrators to test password strength and identify weak passwords.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    # Display a menu for user input
    show_description "jtr"
    # Prompt for mode selection
    read -p "Select mode: [1] Single, [2] Wordlist, [3] /etc/UN-shadow, [4] Kerberos AFS, [5] Show cracked Passwords, [6] Restore: " mode
    # Mode 1: Crack a single hash
    if [[ $mode == 1 ]]; then
        desc="Available hash formats:
        descrypt, bsdicrypt, md5crypt, md5crypt-long, bcrypt, scrypt, LM, AFS, tripcode, AndroidBackup, adxcrypt, agilekeychain, aix-ssha1, aix-ssha256, aix-ssha512, andOTP, ansible, argon2, as400-des, as400-ssha1, asa-md5, AxCrypt, AzureAD, BestCrypt, BestCryptVE4, bfegg, Bitcoin, BitLocker, bitshares, Bitwarden, BKS, Blackberry-ES10, WoWSRP, Blockchain, chap, Clipperz, cloudkeychain, dynamic_n, cq, CRC32, cryptoSafe, sha1crypt, sha256crypt, sha512crypt, Citrix_NS10, dahua, dashlane, diskcryptor, Django, django-scrypt, dmd5, dmg, dominosec, dominosec8, DPAPImk, dragonfly3-32, dragonfly3-64, dragonfly4-32, dragonfly4-64, Drupal7, eCryptfs, eigrp, electrum, EncFS, enpass, EPI, EPiServer, ethereum, fde, Fortigate256, Fortigate, FormSpring, FVDE, geli, gost, gpg, HAVAL-128-4, HAVAL-256-3, hdaa, hMailServer, hsrp, IKE, ipb2, itunes-backup, iwork, KeePass, keychain, keyring, keystore, known_hosts, krb4, krb5, krb5asrep, krb5pa-sha1, krb5tgs, krb5-17, krb5-18, krb5-3, kwallet, lp, lpcli, leet, lotus5, lotus85, LUKS, MD2, mdc2, MediaWiki, monero, money, MongoDB, scram, Mozilla, mscash, mscash2, MSCHAPv2, mschapv2-naive, krb5pa-md5, mssql, mssql05, mssql12, multibit, mysqlna, mysql-sha1, mysql, net-ah, nethalflm, netlm, netlmv2, net-md5, netntlmv2, netntlm, netntlm-naive, net-sha1, nk, notes, md5ns, nsec3, NT, o10glogon, o3logon, o5logon, ODF, Office, oldoffice, OpenBSD-SoftRAID, openssl-enc, oracle, oracle11, Oracle12C, osc, ospf, Padlock, Palshop, Panama, PBKDF2-HMAC-MD4, PBKDF2-HMAC-MD5, PBKDF2-HMAC-SHA1, PBKDF2-HMAC-SHA256, PBKDF2-HMAC-SHA512, PDF, PEM, pfx, pgpdisk, pgpsda, pgpwde, phpass, PHPS, PHPS2, pix-md5, PKZIP, po, postgres, PST, PuTTY, pwsafe, qnx, RACF, RACF-KDFAES, radius, RAdmin, RAKP, rar, RAR5, Raw-SHA512, Raw-Blake2, Raw-Keccak, Raw-Keccak-256, Raw-MD4, Raw-MD5, Raw-MD5u, Raw-SHA1, Raw-SHA1-AxCrypt, Raw-SHA1-Linkedin, Raw-SHA224, Raw-SHA256, Raw-SHA3, Raw-SHA384, restic, ripemd-128, ripemd-160, rsvp, RVARY, Siemens-S7, Salted-SHA1, SSHA512, sapb, sapg, saph, sappse, securezip, 7z, Signal, SIP, skein-256, skein-512, skey, SL3, Snefru-128, Snefru-256, LastPass, SNMP, solarwinds, SSH, sspr, Stribog-256, Stribog-512, STRIP, SunMD5, SybaseASE, Sybase-PROP, tacacs-plus, tcp-md5, telegram, tezos, Tiger, tc_aes_xts, tc_ripemd160, tc_ripemd160boot, tc_sha512, tc_whirlpool, vdi, OpenVMS, vmx, VNC, vtp, wbb3, whirlpool, whirlpool0, whirlpool1, wpapsk, wpapsk-pmk, xmpp-scram, xsha, xsha512, zed, ZIP, ZipMonster, plaintext, has-160, HMAC-MD5, HMAC-SHA1, HMAC-SHA224, HMAC-SHA256, HMAC-SHA384, HMAC-SHA512, dummy, crypt"
        show_description "jtr"
        read -p "Enter a session name: " session
        read -p "Enter hash to crack: " hash
        read -p "Enter hash format (choose from the above list i.e. raw-md5): " format
        echo "$hash" >hashes/pwd.txt
        results=$(john --session="$session" hashes/pwd.txt --format="$format")
        previous_command="john --session=$session --format=$format hashes/pwd.txt"

    # Mode 2: Crack with a wordlist
    elif [[ $mode == 2 ]]; then
        desc="Available hash formats:
        descrypt, bsdicrypt, md5crypt, md5crypt-long, bcrypt, scrypt, LM, AFS, tripcode, AndroidBackup, adxcrypt, agilekeychain, aix-ssha1, aix-ssha256, aix-ssha512, andOTP, ansible, argon2, as400-des, as400-ssha1, asa-md5, AxCrypt, AzureAD, BestCrypt, BestCryptVE4, bfegg, Bitcoin, BitLocker, bitshares, Bitwarden, BKS, Blackberry-ES10, WoWSRP, Blockchain, chap, Clipperz, cloudkeychain, dynamic_n, cq, CRC32, cryptoSafe, sha1crypt, sha256crypt, sha512crypt, Citrix_NS10, dahua, dashlane, diskcryptor, Django, django-scrypt, dmd5, dmg, dominosec, dominosec8, DPAPImk, dragonfly3-32, dragonfly3-64, dragonfly4-32, dragonfly4-64, Drupal7, eCryptfs, eigrp, electrum, EncFS, enpass, EPI, EPiServer, ethereum, fde, Fortigate256, Fortigate, FormSpring, FVDE, geli, gost, gpg, HAVAL-128-4, HAVAL-256-3, hdaa, hMailServer, hsrp, IKE, ipb2, itunes-backup, iwork, KeePass, keychain, keyring, keystore, known_hosts, krb4, krb5, krb5asrep, krb5pa-sha1, krb5tgs, krb5-17, krb5-18, krb5-3, kwallet, lp, lpcli, leet, lotus5, lotus85, LUKS, MD2, mdc2, MediaWiki, monero, money, MongoDB, scram, Mozilla, mscash, mscash2, MSCHAPv2, mschapv2-naive, krb5pa-md5, mssql, mssql05, mssql12, multibit, mysqlna, mysql-sha1, mysql, net-ah, nethalflm, netlm, netlmv2, net-md5, netntlmv2, netntlm, netntlm-naive, net-sha1, nk, notes, md5ns, nsec3, NT, o10glogon, o3logon, o5logon, ODF, Office, oldoffice, OpenBSD-SoftRAID, openssl-enc, oracle, oracle11, Oracle12C, osc, ospf, Padlock, Palshop, Panama, PBKDF2-HMAC-MD4, PBKDF2-HMAC-MD5, PBKDF2-HMAC-SHA1, PBKDF2-HMAC-SHA256, PBKDF2-HMAC-SHA512, PDF, PEM, pfx, pgpdisk, pgpsda, pgpwde, phpass, PHPS, PHPS2, pix-md5, PKZIP, po, postgres, PST, PuTTY, pwsafe, qnx, RACF, RACF-KDFAES, radius, RAdmin, RAKP, rar, RAR5, Raw-SHA512, Raw-Blake2, Raw-Keccak, Raw-Keccak-256, Raw-MD4, Raw-MD5, Raw-MD5u, Raw-SHA1, Raw-SHA1-AxCrypt, Raw-SHA1-Linkedin, Raw-SHA224, Raw-SHA256, Raw-SHA3, Raw-SHA384, restic, ripemd-128, ripemd-160, rsvp, RVARY, Siemens-S7, Salted-SHA1, SSHA512, sapb, sapg, saph, sappse, securezip, 7z, Signal, SIP, skein-256, skein-512, skey, SL3, Snefru-128, Snefru-256, LastPass, SNMP, solarwinds, SSH, sspr, Stribog-256, Stribog-512, STRIP, SunMD5, SybaseASE, Sybase-PROP, tacacs-plus, tcp-md5, telegram, tezos, Tiger, tc_aes_xts, tc_ripemd160, tc_ripemd160boot, tc_sha512, tc_whirlpool, vdi, OpenVMS, vmx, VNC, vtp, wbb3, whirlpool, whirlpool0, whirlpool1, wpapsk, wpapsk-pmk, xmpp-scram, xsha, xsha512, zed, ZIP, ZipMonster, plaintext, has-160, HMAC-MD5, HMAC-SHA1, HMAC-SHA224, HMAC-SHA256, HMAC-SHA384, HMAC-SHA512, dummy, crypt"
        show_description "jtr"
        read -p "Enter a session name: " session
        read -p "Enter hash to crack: " hash
        read -p "Enter hash format (choose from the above list i.e. raw-md5): " format
        echo "$hash" >hashes/pwd.txt
        read -p "Enter path to wordlist (default = /usr/share/wordlists/rockyou.txt): " wordlist
        if [ -z "$wordlist" ]; then
            wordlist="/usr/share/wordlists/rockyou.txt"
            if [ ! -f "$wordlist" ] && [ -f "/usr/share/wordlists/rockyou.txt.gz" ]; then
                echo "rockyou.txt not found, but rockyou.txt.gz exists. Unzipping..."
                sudo gunzip "/usr/share/wordlists/rockyou.txt.gz"

                if [ -f "$wordlist" ]; then
                    echo "Unzipping successful. rockyou.txt is now available."
                else
                    echo "Error: Unzipping failed. rockyou.txt is still not available."
                    exit 1
                fi
            elif [ ! -f "$wordlist" ] && [ ! -f "/usr/share/wordlists/rockyou.txt.gz" ]; then
                echo "Error: Wordlist not found at $wordlist or /usr/share/wordlists/rockyou.txt.gz"
                exit 1
            fi
        else
            if [ ! -f "$wordlist" ]; then
                echo "Error: Wordlist not found at $wordlist"
                exit 1
            fi
        fi
        results=$(john --session="$session" --wordlist="$wordlist" --format="$format" hashes/pwd.txt)
        previous_command="john --session=$session --wordlist=$wordlist --format=$format hashes/pwd.txt"
    # Mode 3: Unshadow /etc/passwd and /etc/shadow
    elif [[ $mode == 3 ]]; then
        desc="Available hash formats:
        descrypt, bsdicrypt, md5crypt, md5crypt-long, bcrypt, scrypt, LM, AFS, tripcode, AndroidBackup, adxcrypt, agilekeychain, aix-ssha1, aix-ssha256, aix-ssha512, andOTP, ansible, argon2, as400-des, as400-ssha1, asa-md5, AxCrypt, AzureAD, BestCrypt, BestCryptVE4, bfegg, Bitcoin, BitLocker, bitshares, Bitwarden, BKS, Blackberry-ES10, WoWSRP, Blockchain, chap, Clipperz, cloudkeychain, dynamic_n, cq, CRC32, cryptoSafe, sha1crypt, sha256crypt, sha512crypt, Citrix_NS10, dahua, dashlane, diskcryptor, Django, django-scrypt, dmd5, dmg, dominosec, dominosec8, DPAPImk, dragonfly3-32, dragonfly3-64, dragonfly4-32, dragonfly4-64, Drupal7, eCryptfs, eigrp, electrum, EncFS, enpass, EPI, EPiServer, ethereum, fde, Fortigate256, Fortigate, FormSpring, FVDE, geli, gost, gpg, HAVAL-128-4, HAVAL-256-3, hdaa, hMailServer, hsrp, IKE, ipb2, itunes-backup, iwork, KeePass, keychain, keyring, keystore, known_hosts, krb4, krb5, krb5asrep, krb5pa-sha1, krb5tgs, krb5-17, krb5-18, krb5-3, kwallet, lp, lpcli, leet, lotus5, lotus85, LUKS, MD2, mdc2, MediaWiki, monero, money, MongoDB, scram, Mozilla, mscash, mscash2, MSCHAPv2, mschapv2-naive, krb5pa-md5, mssql, mssql05, mssql12, multibit, mysqlna, mysql-sha1, mysql, net-ah, nethalflm, netlm, netlmv2, net-md5, netntlmv2, netntlm, netntlm-naive, net-sha1, nk, notes, md5ns, nsec3, NT, o10glogon, o3logon, o5logon, ODF, Office, oldoffice, OpenBSD-SoftRAID, openssl-enc, oracle, oracle11, Oracle12C, osc, ospf, Padlock, Palshop, Panama, PBKDF2-HMAC-MD4, PBKDF2-HMAC-MD5, PBKDF2-HMAC-SHA1, PBKDF2-HMAC-SHA256, PBKDF2-HMAC-SHA512, PDF, PEM, pfx, pgpdisk, pgpsda, pgpwde, phpass, PHPS, PHPS2, pix-md5, PKZIP, po, postgres, PST, PuTTY, pwsafe, qnx, RACF, RACF-KDFAES, radius, RAdmin, RAKP, rar, RAR5, Raw-SHA512, Raw-Blake2, Raw-Keccak, Raw-Keccak-256, Raw-MD4, Raw-MD5, Raw-MD5u, Raw-SHA1, Raw-SHA1-AxCrypt, Raw-SHA1-Linkedin, Raw-SHA224, Raw-SHA256, Raw-SHA3, Raw-SHA384, restic, ripemd-128, ripemd-160, rsvp, RVARY, Siemens-S7, Salted-SHA1, SSHA512, sapb, sapg, saph, sappse, securezip, 7z, Signal, SIP, skein-256, skein-512, skey, SL3, Snefru-128, Snefru-256, LastPass, SNMP, solarwinds, SSH, sspr, Stribog-256, Stribog-512, STRIP, SunMD5, SybaseASE, Sybase-PROP, tacacs-plus, tcp-md5, telegram, tezos, Tiger, tc_aes_xts, tc_ripemd160, tc_ripemd160boot, tc_sha512, tc_whirlpool, vdi, OpenVMS, vmx, VNC, vtp, wbb3, whirlpool, whirlpool0, whirlpool1, wpapsk, wpapsk-pmk, xmpp-scram, xsha, xsha512, zed, ZIP, ZipMonster, plaintext, has-160, HMAC-MD5, HMAC-SHA1, HMAC-SHA224, HMAC-SHA256, HMAC-SHA384, HMAC-SHA512, dummy, crypt"
        show_description "jtr"
        read -p "Enter a session name: " session
        read -p "Enter path of file to unshadow (default = /etc/passwd): " file
        read -p "Enter shadow file to use (default = /etc/shadow): " file2
        # Set defaults if necessary
        if [[ -z "$file" ]]; then
            file="/etc/passwd"
        fi
        if [[ -z "$file2" ]]; then
            file2="/etc/shadow"
        fi
        # Unshadow files and crack them
        unshadow "$file" "$file2" >hashes/pwd.txt
        read -p "Enter hash format (choose from the above list i.e. raw-md5): " format
        read -p "Enter path to wordlist (Enter for JTR default wordlist): " wordlist
        if [[ -z "$wordlist" ]]; then
            results=$(john --session="$session" --format="$format" hashes/pwd.txt)
            previous_command="john --session=$session --format=$format hashes/pwd.txt"
        else
            results=$(john --session="$session" --wordlist="$wordlist" --format="$format"hashes/pwd.txt)
            previous_command="john --session=$session --wordlist=$wordlist --format=$format hashes/pwd.txt"
        fi
    elif [[ $mode == 4 ]]; then
        desc="Available hash formats:
        descrypt, bsdicrypt, md5crypt, md5crypt-long, bcrypt, scrypt, LM, AFS, tripcode, AndroidBackup, adxcrypt, agilekeychain, aix-ssha1, aix-ssha256, aix-ssha512, andOTP, ansible, argon2, as400-des, as400-ssha1, asa-md5, AxCrypt, AzureAD, BestCrypt, BestCryptVE4, bfegg, Bitcoin, BitLocker, bitshares, Bitwarden, BKS, Blackberry-ES10, WoWSRP, Blockchain, chap, Clipperz, cloudkeychain, dynamic_n, cq, CRC32, cryptoSafe, sha1crypt, sha256crypt, sha512crypt, Citrix_NS10, dahua, dashlane, diskcryptor, Django, django-scrypt, dmd5, dmg, dominosec, dominosec8, DPAPImk, dragonfly3-32, dragonfly3-64, dragonfly4-32, dragonfly4-64, Drupal7, eCryptfs, eigrp, electrum, EncFS, enpass, EPI, EPiServer, ethereum, fde, Fortigate256, Fortigate, FormSpring, FVDE, geli, gost, gpg, HAVAL-128-4, HAVAL-256-3, hdaa, hMailServer, hsrp, IKE, ipb2, itunes-backup, iwork, KeePass, keychain, keyring, keystore, known_hosts, krb4, krb5, krb5asrep, krb5pa-sha1, krb5tgs, krb5-17, krb5-18, krb5-3, kwallet, lp, lpcli, leet, lotus5, lotus85, LUKS, MD2, mdc2, MediaWiki, monero, money, MongoDB, scram, Mozilla, mscash, mscash2, MSCHAPv2, mschapv2-naive, krb5pa-md5, mssql, mssql05, mssql12, multibit, mysqlna, mysql-sha1, mysql, net-ah, nethalflm, netlm, netlmv2, net-md5, netntlmv2, netntlm, netntlm-naive, net-sha1, nk, notes, md5ns, nsec3, NT, o10glogon, o3logon, o5logon, ODF, Office, oldoffice, OpenBSD-SoftRAID, openssl-enc, oracle, oracle11, Oracle12C, osc, ospf, Padlock, Palshop, Panama, PBKDF2-HMAC-MD4, PBKDF2-HMAC-MD5, PBKDF2-HMAC-SHA1, PBKDF2-HMAC-SHA256, PBKDF2-HMAC-SHA512, PDF, PEM, pfx, pgpdisk, pgpsda, pgpwde, phpass, PHPS, PHPS2, pix-md5, PKZIP, po, postgres, PST, PuTTY, pwsafe, qnx, RACF, RACF-KDFAES, radius, RAdmin, RAKP, rar, RAR5, Raw-SHA512, Raw-Blake2, Raw-Keccak, Raw-Keccak-256, Raw-MD4, Raw-MD5, Raw-MD5u, Raw-SHA1, Raw-SHA1-AxCrypt, Raw-SHA1-Linkedin, Raw-SHA224, Raw-SHA256, Raw-SHA3, Raw-SHA384, restic, ripemd-128, ripemd-160, rsvp, RVARY, Siemens-S7, Salted-SHA1, SSHA512, sapb, sapg, saph, sappse, securezip, 7z, Signal, SIP, skein-256, skein-512, skey, SL3, Snefru-128, Snefru-256, LastPass, SNMP, solarwinds, SSH, sspr, Stribog-256, Stribog-512, STRIP, SunMD5, SybaseASE, Sybase-PROP, tacacs-plus, tcp-md5, telegram, tezos, Tiger, tc_aes_xts, tc_ripemd160, tc_ripemd160boot, tc_sha512, tc_whirlpool, vdi, OpenVMS, vmx, VNC, vtp, wbb3, whirlpool, whirlpool0, whirlpool1, wpapsk, wpapsk-pmk, xmpp-scram, xsha, xsha512, zed, ZIP, ZipMonster, plaintext, has-160, HMAC-MD5, HMAC-SHA1, HMAC-SHA224, HMAC-SHA256, HMAC-SHA384, HMAC-SHA512, dummy, crypt"
        show_description "jtr"
        read -p "Enter a session name: " session
        read -p "Enter path to the Kerberos AFS credentials file: " file
        unafs "$file" >hashes/pwd.txt
        read -p "Enter hash format (choose from the above list i.e. raw-md5): " format
        read -p "Enter path to wordlist (Enter for JTR default wordlist): " wordlist
        if [[ -z "$wordlist" ]]; then
            results=$(john --session="$session" --format="$format" hashes/pwd.txt)
            previous_command="john --session=$session --format=$format hashes/pwd.txt"
        else
            results=$(john --session="$session" --wordlist="$wordlist" --format="$format" hashes/pwd.txt)
            previous_command="john --session=$session --wordlist=$wordlist --format=$format hashes/pwd.txt"
        fi
    elif [[ $mode == 5 ]]; then
        desc="Available hash formats:
        descrypt, bsdicrypt, md5crypt, md5crypt-long, bcrypt, scrypt, LM, AFS, tripcode, AndroidBackup, adxcrypt, agilekeychain, aix-ssha1, aix-ssha256, aix-ssha512, andOTP, ansible, argon2, as400-des, as400-ssha1, asa-md5, AxCrypt, AzureAD, BestCrypt, BestCryptVE4, bfegg, Bitcoin, BitLocker, bitshares, Bitwarden, BKS, Blackberry-ES10, WoWSRP, Blockchain, chap, Clipperz, cloudkeychain, dynamic_n, cq, CRC32, cryptoSafe, sha1crypt, sha256crypt, sha512crypt, Citrix_NS10, dahua, dashlane, diskcryptor, Django, django-scrypt, dmd5, dmg, dominosec, dominosec8, DPAPImk, dragonfly3-32, dragonfly3-64, dragonfly4-32, dragonfly4-64, Drupal7, eCryptfs, eigrp, electrum, EncFS, enpass, EPI, EPiServer, ethereum, fde, Fortigate256, Fortigate, FormSpring, FVDE, geli, gost, gpg, HAVAL-128-4, HAVAL-256-3, hdaa, hMailServer, hsrp, IKE, ipb2, itunes-backup, iwork, KeePass, keychain, keyring, keystore, known_hosts, krb4, krb5, krb5asrep, krb5pa-sha1, krb5tgs, krb5-17, krb5-18, krb5-3, kwallet, lp, lpcli, leet, lotus5, lotus85, LUKS, MD2, mdc2, MediaWiki, monero, money, MongoDB, scram, Mozilla, mscash, mscash2, MSCHAPv2, mschapv2-naive, krb5pa-md5, mssql, mssql05, mssql12, multibit, mysqlna, mysql-sha1, mysql, net-ah, nethalflm, netlm, netlmv2, net-md5, netntlmv2, netntlm, netntlm-naive, net-sha1, nk, notes, md5ns, nsec3, NT, o10glogon, o3logon, o5logon, ODF, Office, oldoffice, OpenBSD-SoftRAID, openssl-enc, oracle, oracle11, Oracle12C, osc, ospf, Padlock, Palshop, Panama, PBKDF2-HMAC-MD4, PBKDF2-HMAC-MD5, PBKDF2-HMAC-SHA1, PBKDF2-HMAC-SHA256, PBKDF2-HMAC-SHA512, PDF, PEM, pfx, pgpdisk, pgpsda, pgpwde, phpass, PHPS, PHPS2, pix-md5, PKZIP, po, postgres, PST, PuTTY, pwsafe, qnx, RACF, RACF-KDFAES, radius, RAdmin, RAKP, rar, RAR5, Raw-SHA512, Raw-Blake2, Raw-Keccak, Raw-Keccak-256, Raw-MD4, Raw-MD5, Raw-MD5u, Raw-SHA1, Raw-SHA1-AxCrypt, Raw-SHA1-Linkedin, Raw-SHA224, Raw-SHA256, Raw-SHA3, Raw-SHA384, restic, ripemd-128, ripemd-160, rsvp, RVARY, Siemens-S7, Salted-SHA1, SSHA512, sapb, sapg, saph, sappse, securezip, 7z, Signal, SIP, skein-256, skein-512, skey, SL3, Snefru-128, Snefru-256, LastPass, SNMP, solarwinds, SSH, sspr, Stribog-256, Stribog-512, STRIP, SunMD5, SybaseASE, Sybase-PROP, tacacs-plus, tcp-md5, telegram, tezos, Tiger, tc_aes_xts, tc_ripemd160, tc_ripemd160boot, tc_sha512, tc_whirlpool, vdi, OpenVMS, vmx, VNC, vtp, wbb3, whirlpool, whirlpool0, whirlpool1, wpapsk, wpapsk-pmk, xmpp-scram, xsha, xsha512, zed, ZIP, ZipMonster, plaintext, has-160, HMAC-MD5, HMAC-SHA1, HMAC-SHA224, HMAC-SHA256, HMAC-SHA384, HMAC-SHA512, dummy, crypt"
        show_description "jtr"
        read -p "Enter hash format (choose from the above list i.e. raw-md5): " format
        results=$(john --show --format="$format" hashes/pwd.txt)
        previous_command="john --show --format=$format hashes/pwd.txt"
    elif [[ $mode == 6 ]]; then
        read -p "Enter a session name: " session
        results=$(john --restore="$session")
        previous_command="john --restore=$session"
    else
        echo "Invalid mode selected. Please try again."
    fi
    log_action "$previous_command"
    results
    results=$(john --show --format="$format" hashes/pwd.txt)
    results
}

# Function to perform Hashcat password cracking
perform_hashcat() {
    results=""
    desc="Hashcat is an advanced password recovery tool designed to crack or recover passwords from encrypted hashes. It is widely used by security professionals, penetration testers, and ethical hackers to test the strength of hashed passwords, identify security vulnerabilities, and assess the effectiveness of password policies.

    While Hashcat is a powerful tool for password recovery and security testing, it's crucial to use it responsibly and ethically. Unauthorized use of Hashcat to crack passwords or access unauthorized data is illegal and unethical. Always ensure you have permission and appropriate authorization before using Hashcat in any context.
    
    ---Cheatsheet/Usage available in /cheatsheet--- "
    show_description "hashcat"
    read -p "Enter the password file to crack: " password_file
    read -p "Enter hash type: " mode
    read -p "Enter attack vector: (i.e. [0] straight, [1] combo, [3] brute-force, [6] hybrid wordlist + mask, [7] hybrid mask + wordlist, [9] association ): " attack
    read -p "Enter path to wordlist (default = /usr/share/wordlists/rockyou.txt): " wordlist
    if [ -z "$wordlist" ]; then
        wordlist="/usr/share/wordlists/rockyou.txt"
        if [ ! -f "$wordlist" ] && [ -f "/usr/share/wordlists/rockyou.txt.gz" ]; then
            echo "rockyou.txt not found, but rockyou.txt.gz exists. Unzipping..."
            sudo gunzip "/usr/share/wordlists/rockyou.txt.gz"

            if [ -f "$wordlist" ]; then
                echo "Unzipping successful. rockyou.txt is now available."
            else
                echo "Error: Unzipping failed. rockyou.txt is still not available."
                exit 1
            fi
        elif [ ! -f "$wordlist" ] && [ ! -f "/usr/share/wordlists/rockyou.txt.gz" ]; then
            echo "Error: Wordlist not found at $wordlist or /usr/share/wordlists/rockyou.txt.gz"
            exit 1
        fi
    else
        if [ ! -f "$wordlist" ]; then
            echo "Error: Wordlist not found at $wordlist"
            exit 1
        fi
    fi
    results=$(hashcat -m "$mode" -a "$attack" "$password_file" "$wordlist")

    previous_command="hashcat -m $mode -a $attack  $password_file $wordlist"
    log_action "$previous_command"
    results
}

# Function to perform Hydra attack
perform_hydra() {
    results=""
    desc="Hydra (often referred to as THC-Hydra) is a popular password-cracking tool used in Kali Linux and other penetration testing environments. It is designed to perform rapid brute-force or dictionary-based attacks against various network services and protocols to gain unauthorized access by guessing passwords. Hydra is widely used by security professionals, penetration testers, and ethical hackers to assess the security of network services and to identify weak or easily guessed passwords.
    
    ---Cheatsheet/Usage available in /cheatsheet--- "
    show_description "hydra"
    read -p "Enter the target: " target
    read -p "Single user/pass mode? (y/n): " mode
    if [[ $mode =~ ^[Yy]$ ]]; then
        desc="
    Supported services: 
adam6500 asterisk cisco cisco-enable cobaltstrike cvs firebird ftp[s] http[s]-{head|get|post} 
http[s]-{get|post}-form http-proxy http-proxy-urlenum icq imap[s] irc ldap2[s] ldap3[-{cram|digest}md5][s] 
memcached mongodb mssql mysql nntp oracle-listener oracle-sid pcanywhere pcnfs pop3[s] postgres radmin2 rdp 
redis rexec rlogin rpcap rsh rtsp s7-300 sip smb smtp[s] smtp-enum snmp socks5 ssh sshkey svn teamspeak 
telnet[s] vmauthd vnc xmpp"
        show_description "hydra"
        read -p "Enter the username: " user
        read -p "Enter the password: " pass
        read -p "Enter the service: " service
        read -p "Enter the port: " port
        read -p "Enter the URL w/ ^USER^ and ^PASS^ as the parameters (e.g. /path/to/web/login/index.php?userField=^USER^&passwordField=^PASS^): " params
        results=$(hydra -l "$user" -p "$pass" "$target" -s "$port" "$service" "$params")
        previous_command="hydra -l $user -p $pass $target -s $port $service $params"
    else
        read -p "Enter the username file: " user
        if [ ! -f "$user" ]; then
            echo "Error: Username file does not exist."
            return 1
        fi
        desc="
    Supported services: 
adam6500 asterisk cisco cisco-enable cobaltstrike cvs firebird ftp[s] http[s]-{head|get|post} 
http[s]-{get|post}-form http-proxy http-proxy-urlenum icq imap[s] irc ldap2[s] ldap3[-{cram|digest}md5][s] 
memcached mongodb mssql mysql nntp oracle-listener oracle-sid pcanywhere pcnfs pop3[s] postgres radmin2 rdp 
redis rexec rlogin rpcap rsh rtsp s7-300 sip smb smtp[s] smtp-enum snmp socks5 ssh sshkey svn teamspeak 
telnet[s] vmauthd vnc xmpp"
        show_description "hydra"
        read -p "Enter the password file: " pass
        read -p "Enter the service: " service
        read -p "Enter the port: " port
        read -p "Enter the URL w/ ^USER^ and ^PASS^ as the parameters (e.g. /path/to/web/login/index.php?userField=^USER^&passwordField=^PASS^): " params
        if [ ! -f "$pass" ]; then
            echo "Error: Password file does not exist."
            return 1
        fi
        results=$(hydra -L "$user" -P "$pass" "$target" -s "$port" "$service" "$params")
        previous_command="hydra -L $user -P $pass $target -s $port $service $params"
    fi
    log_action "$previous_command"
    results

}

# Fuunction to brute fore with Medusa
perform_medusa() {
    results=""
    desc="Medusa is a fast, parallel, and modular login brute-forcer. It is used to test and break into remote systems by attempting multiple login credentials in parallel. This tool is particularly useful for penetration testers and security researchers who need to test the security of their systems against brute-force attacks.

---Cheatsheet/Usage available in /cheatsheet---"
    show_description "medusa"
    read -p "Enter Target Host, IP address or file containing Hosts/IPs: " target
    read -p "user/pass combo file? (y/n) " ask
    if [[ $ask =~ ^[Yy]$ ]]; then
        echo "Valid combos - host:username:password, host:username:, host::, :username:password, :username:, ::password, host::password"
        read -p "Enter combo file location: " combo
        combo_option="-c"
    else
        read -p "Enter username or username_file.txt: " user
        if [[ -f "$user" ]]; then
            user_option="-U"
        else
            user_option="-u"
        fi
        read -p "Enter password or password_file.txt: " pass
        if [[ -f "$pass" ]]; then
            pass_option="-P"
        else
            pass_option="-p"
        fi
    fi
    echo " Available modules: cvs, ftp, http, imap, mssql, mysql, nntp, pcanywhere, pop3, postgres, rexec, rlogin, rsh, smbnt, smtp-vrfy, smtp, snmp, ssh, svn, telnet, vmauthd, vnc, web-form, wrapper"
    read -p "Enter Module: " module

    case $module in
    "cvs")
        echo "This allows the user to specify the target CVSROOT path. For example, :pserver:USER@HOST:/SOME_DIR. If the option is not set, the default behaviour is to use /root"
        read -p "Module options: (DIR:/some_project) set CVSROOT path: " opt
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M cvs -m "$opt")
            previous_command="medusa -h $target $combo_option $combo -M cvs -m $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M cvs -m "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M cvs -m $opt"
        fi
        ;;
    "ftp")
        echo "
        Available module options:
MODE:? (NORMAL*, EXPLICIT, IMPLICIT)

  EXPLICIT: AUTH TLS Mode as defined in RFC 4217
     Explicit FTPS (FTP/SSL) connects to a FTP service in the clear. Prior to
     sending any credentials, however, an \"AUTH TLS\" command is issued and a
     SSL session is negotiated.

  IMPLICIT: FTP over SSL (990/tcp)
     Implicit FTPS requires a SSL handshake to be performed before any FTP
     commands are sent. This service typically resides on tcp/990. If the user
     specifies this option or uses the \"-s\" (SSL) option, the module will
     default to this mode and tcp/990.

  NORMAL
     The default behaviour if no MODE is specified. Authentication is attempted
     in the clear. If the server requests encryption for the given user,
     Explicit FTPS is utilized."
        read -p "Module options: (MODE:? (NORMAL, EXPLICIT, IMPLICIT)): " mode

        opt=""
        [[ -n "$mode" ]] && opt="-m MODE:$mode "

        # Remove trailing space
        opt="${opt% }"
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M ftp "$opt")
            previous_command="medusa -h $target $combo_option $combo -M ftp $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M ftp "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M ftp $opt"
        fi
        ;;
    "http")
        echo "
        Available module options:
  USER-AGENT:? (User-Agent. Default: Mozilla/1.22 (compatible; MSIE 10.0; Windows 3.1))
  DIR:? (Target directory. Default "/")
  AUTH:? (Authentication Type (BASIC/DIGEST/NTLM). Default: automatic)
  DOMAIN:? [optional]
  CUSTOM-HEADER:?    Additional HTTP header.
                     More headers can be defined by using this option several times.
"
        read -p "Enter target port: " port
        read -p "USER-AGENT (leave empty for default): " user_agent
        read -p "DIR (leave empty for default '/'): " dir
        read -p "AUTH (BASIC/DIGEST/NTLM) Default: automatic: " auth
        read -p "DOMAIN (optional): " domain
        read -p "CUSTOM-HEADER (i.e Cookie: admin=true)(optional, can be multiple): " custom_header

        # Constructing module options
        opt=""
        [[ -n "$user_agent" ]] && opt+="-m USER-AGENT:\"$user_agent\" "
        [[ -n "$dir" ]] && opt+="-m DIR:$dir "
        [[ -n "$auth" ]] && opt+="-m AUTH:$auth "
        [[ -n "$domain" ]] && opt+="-m DOMAIN:$domain "
        [[ -n "$custom_header" ]] && opt+="-m CUSTOM-HEADER:\"$custom_header\" "

        # Remove trailing space if exists
        opt="${opt% }"
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" -n "$port" "$combo_option" "$combo" -M http "$opt")
            previous_command="medusa -h $target -n $port $combo_option $combo -M http $opt"
        else
            results=$(medusa -h "$target" -n "$port" "$user_option" "$user" "$pass_option" "$pass" -M http "$opt")
            previous_command="medusa -h $target -n $port $user_option $user $pass_option $pass -M http $opt"
        fi
        ;;
    "imap")
        echo "
        Available module options:
  TAG:? (Default: gerg)
  AUTH:? (Authentication Type (LOGIN/PLAIN/NTLM). Default: automatic)
  DOMAIN:? [optional]"
        read -p "TAG (leave empty for default 'gerg'): " tag
        read -p "AUTH (LOGIN/PLAIN/NTLM) Default: automatic: " auth
        read -p "DOMAIN (optional): " domain
        # Constructing module options
        opt=""
        [[ -n "$TAG" ]] && opt+="-m TAG:$tag "
        [[ -n "$auth" ]] && opt+="-m AUTH:$auth "
        [[ -n "$domain" ]] && opt+="-m DOMAIN:$domain "
        # Remove trailing space if exists
        opt="${opt% }"
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M imap "$opt")
            previous_command="medusa -h $target $combo_option $combo -M imap $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M imap "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M imap $opt"
        fi
        ;;
    "mssql")
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M mssql)
            previous_command="medusa -h $target $combo_option $combo -M mssql"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M mssql)
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M mssq"
        fi
        ;;
    "mysql")
        echo "
        Available module options:
  PASS:?  (PASSWORD*, HASH)
    PASSWORD: Use normal password.
    HASH:     Use a hash rather than a password. (non-SHA1 hashes only)"
        read -p "PASS (leave empty for default of PASSWORD) enter hash: " pass

        # Constructing module options
        opt=""
        [[ -n "$pass" ]] && opt+="-m PASS:$pass "
        # Remove trailing space if exists
        opt="${opt% }"

        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M mysql "$opt")
            previous_command="medusa -h $target $combo_option $combo -M mysql $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M mysql "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M mysql $opt"
        fi
        ;;
    "nntp")
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M nntp)
            previous_command="medusa -h $target $combo_option $combo -M nntp"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M nntp)
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M nntp"
        fi
        ;;
    "pcanywhere")
        echo "
        Module based on packet captures from Server Version 10.5.1 and Client 10.0.2.
PCA Authentication Methods:
   ADS (Active Directory Services) [1]
   FTP [2]
   HTTP [2]
   HTTPS [2]
   Microsoft LDAP [2]
   Netscape LDAP [2]
   Novell LDAP [2]
   NT [1]
   pcAnywhere [1]
   Windows [3]

[1] Verified working
[2] Untested
[3] Verified to work when PcAnywhere host authenticates against domain accounts.
Authentication fails for local accounts with both the module and the PcAnywhere
client. Not sure what's going on..."
        echo "Available module options:
  DOMAIN:?
    Option allows manual setting of domain to check against when host uses NT authentication."

        read -p "Enter DOMAIN: " domain

        # Constructing module options
        opt=""
        [[ -n "$domain" ]] && opt+="-m DOMAIN:$domain "
        # Remove trailing space if exists
        opt="${opt% }"

        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M pcanywhere "$opt")
            previous_command="medusa -h $target $combo_option $combo -M pcanywhere $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M pcanywhere "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M pcanywhere $opt"
        fi
        ;;
    "pop3")
        echo "
        Available module options:
  MODE:? (NORMAL, AS400) [optional]
    Sets the mode for error detection.
 AUTH:? (Authentication Type (USER/PLAIN/LOGIN/NTLM). Default: automatic)
    Module will query service for accepted methods via an \"AUTH\" request.
    USER (clear-text), SASL PLAIN, SASL LOGIN, and SASL NTLM authentication methods are supported.
  DOMAIN:? [optional]
    AUTH USER - Appends domain to username (e.g. user@domain.com).
    AUTH NTLM - Supplies specified domain during NTLM authentication. The default
                behaviour is to use the server supplied domain value."

        read -p "MODE: " mode
        read -p "AUTH: " auth
        read -p "DOMAIN: " domain

        # Constructing module options
        opt=""
        [[ -n "$mode" ]] && opt+="-m MODE:$mode "
        [[ -n "$auth" ]] && opt+="-m AUTH:$auth "
        [[ -n "$domain" ]] && opt+="-m DOMAIN:$domain "
        # Remove trailing space if exists
        opt="${opt% }"

        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M pop3 "$opt")
            previous_command="medusa -h $target $combo_option $combo -M pop3 $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M pop3 "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M pop3 $opt"
        fi
        ;;
    "postgres")
        echo "
        The module has a single option, DB. This allows the user to specify the target database name. If the option is not set, the default behaviour is to use template1.

Available module options:
  DB:?
    Sets target database name."

        read -p "Enter DB name (leave empty for default of template1): " db

        # Constructing module options
        opt=""
        [[ -n "$db" ]] && opt+="-m DB:$db "
        # Remove trailing space if exists
        opt="${opt% }"

        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M postgres "$opt")
            previous_command="medusa -h $target $combo_option $combo -M postgres $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M postgres "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M postgres $opt"
        fi
        ;;
    "rexec")
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M rexec)
            previous_command="medusa -h $target $combo_option $combo -M rexe"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M rexec)
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M rexec"
        fi
        ;;
    "rlogin")
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M rlogin)
            previous_command="medusa -h $target $combo_option $combo -M rlogin"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M rlogin)
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M rlogin"
        fi
        ;;
    "rsh")
        echo "
        Rsh is a service where you either have .rhosts/hosts.equiv access
from the source host or you don't. Passwords really don't matter.
So the best way to use this module is with a single dummy password and a
list of users you suspect may have .rhosts/hosts.equiv allows for your source.
Good luck."
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M rsh "$opt")
            previous_command="medusa -h $target $combo_option $combo -M rsh $opt"
        else
            results=$(medusa -h"$target" "$user_option" "$user" "$pass_option" "$pass" -M rsh "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M rsh $opt"
        fi
        ;;
    "smbnt")
        echo "
        Available module options:
  GROUP:? (DOMAIN, LOCAL*, BOTH)
    Option sets NetBIOS workgroup field.
    DOMAIN: Check credentials against this hosts primary domain controller via this host.
    LOCAL:  Check local account.
    BOTH:   Check both. This leaves the workgroup field set blank and then attempts to check
            the credentials against the host. If the account does not exist locally on the
            host being tested, that host then queries its domain controller.
  GROUP_OTHER:?
    Option allows manual setting of domain to check against. Use instead of GROUP.
  PASS:?  (PASSWORD*, HASH, MACHINE)
    PASSWORD: Use normal password.
    HASH:     Use a NTLM hash rather than a password.
    MACHINE:  Use the machine's NetBIOS name as the password.
  AUTH:?  (LM, NTLM, LMv2*, NTLMv2)
    Option sets LAN Manager Authentication level.
    LM:
    NTLM:
    LMv2:
    NTLMv2:
  NETBIOS
    Force NetBIOS Mode (Disable Native Win2000 Mode). Win2000 mode is the default.
    Default mode is to test TCP/445 using Native Win2000. If this fails, module will
    fall back to TCP/139 using NetBIOS mode. To test only TCP/139, use the following:
    medusa -M smbnt -m NETBIOS -n 139

(*) Default value

---This is only the basics, read the cheatsheet for detailed information---"

        read -p "Enter group (leave empty for default of DOMAIN): " group
        read -p "Enter group_other (leave empty for default of DOMAIN): " group_other
        read -p "Enter pass (leave empty for default of PASSWORD): " pass
        read -p "Enter auth (leave empty for default of LM): " auth
        read -p "Enter netbios (y/n): " netbios

        # Constructing module options
        opt=""
        [[ -n "$group" ]] && opt+="-m GROUP:$group "
        [[ -n "$group_other" ]] && opt+=" -m GROUP_OTHER:$group_other "
        [[ -n "$pass" ]] && opt+="-m PASS:$pass "
        [[ -n "$auth" ]] && opt+="-m AUTH:$auth "
        [[ -n "$netbios" ]] && opt+="-m NETBIOS "

        # Remove trailing space if exists
        opt="${opt% }"

        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M smbnt "$opt")
            previous_command="medusa -h $target $combo_option $combo -M smbnt $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M smbnt "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M smbnt $opt"
        fi
        ;;
    "smtp-vrfy")
        echo "
        Available module options:
 HELO [optional]
    Use HELO command. Default: EHLO
 HELODOMAIN:? [optional]
    Specify the HELO/EHLO domain. Default: server.domain
 MAILFROM:? [optional]
    Specify the MAIL FROM address. Default: doesnotexist@foofus.net
 VERB:? (Verb/Command: VRFY/EXPN/RCPT TO. Default: RCPT TO

*** NOTE: Target address domain should be specified within password field. ***"

        read -p "Enter helo (leave empty for default of EHLO): " helo
        read -p "Enter helodomain (leave empty for default of server.domain): " helodomain
        read -p "Enter mailfrom (leave empty for default of doesnotexist@foofus.net): " mailfrom
        read -p "Enter verb (leave empty for default of RCPT TO): " verb

        # Constructing module options
        opt=""
        [[ -n "$helo" ]] && opt+="-m HELO:$helo "
        [[ -n "$helodomain" ]] && opt+="-m HELODOMAIN:$helodomain "
        [[ -n "$mailfrom" ]] && opt+="-m MAILFROM:$mailfrom "
        [[ -n "$verb" ]] && opt+="-m VERB:$verb "

        # Remove trailing space if exists
        opt="${opt% }"
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M smtp-vrfy "$opt")
            previous_command="medusa -h $target $combo_option $combo -M smtp-vrfy $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M smtp-vrfy "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M smtp-vrfy $opt"
        fi
        ;;
    "smtp")
        echo "
        Available module options:
 EHLO:? [optional]
    Specify the EHLO greeting.
 AUTH:? (Authentication Type (PLAIN/LOGIN/NTLM). Default: automatic)
    Module will query service for accepted methods via an \"AUTH\" request.
    PLAIN, LOGIN, and NTLM authentication methods are supported.
  DOMAIN:? [optional]"

        read -p "Enter ehlo (leave empty for default of localhost): " ehlo
        read -p "Enter auth (leave empty for default of automatic): " auth
        read -p "Enter domain (leave empty for default of localhost): " domain

        # Constructing module options
        opt=""
        [[ -n "$ehlo" ]] && opt+="-m EHLO:$ehlo "
        [[ -n "$auth" ]] && opt+="-m AUTH:$auth "
        [[ -n "$domain" ]] && opt+="-m DOMAIN:$domain "

        # Remove trailing space if exists
        opt="${opt% }"
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M smtp "$opt")
            previous_command="medusa -h $target $combo_option $combo -M smtp $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M smtp "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M smtp $opt"
        fi
        ;;
    "snmp")
        echo "
        Available module options:
  TIMEOUT:?
    Sets the number of seconds to wait for the UDP responses (default: 5 sec).
  SEND_DELAY:?
    Sets the number of microseconds to wait between sending queries (default: 200 usec).
  VERSION:? (1*, 2C)
    Set the SNMP client version.
  ACCESS:? (READ*, WRITE)
    Set level of access to test for with the community string.

(*) Default value"

        read -p "Enter timeout (leave empty for default of 5): " timeout
        read -p "Enter send_delay (leave empty for default of 200): " send_delay
        read -p "Enter version (leave empty for default of 1): " version
        read -p "Enter access (leave empty for default of READ): " access

        # Constructing module options
        opt=""
        [[ -n "$timeout" ]] && opt+="-m TIMEOUT:$timeout "
        [[ -n "$send_delay" ]] && opt+="-m SEND_DELAY:$send_delay "
        [[ -n "$version" ]] && opt+="-m VERSION:$version "
        [[ -n "$access" ]] && opt+="-m ACCESS:$access "

        # Remove trailing space if exists
        opt="${opt% }"

        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M snmp "$opt")
            previous_command="medusa -h $target $combo_option $combo -M snmp $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M snmp "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M snmp $opt"
        fi
        ;;
    "ssh")
        echo "
        Available module options:
  BANNER:? (Libssh client banner. Default SSH-2.0-MEDUSA.)"

        read -p "Enter opt (leave empty for default of BANNER): " banner

        opt=""
        [[ -n "$banner" ]] && opt+="-m BANNER:$banner "

        # Remove trailing space if exists
        opt="${opt% }"
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" -c "$combo" -M ssh "$opt")
            previous_command="medusa -h $target -c $combo -M ssh $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M ssh "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M ssh $opt"
        fi
        ;;
    "svn")
        echo "
        Available module options:
  BRANCH:?
    Sets URL branch to authenticate against. For example, svn://host/branch."

        read -p "Enter opt (leave empty for default of BRANCH): " branch

        opt=""
        [[ -n "$branch" ]] && opt+="-m BRANCH:$branch "

        # Remove trailing space if exists
        opt="${opt% }"

        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M svn "$opt")
            previous_command="medusa -h $target $combo_option $combo -M svn $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M svn "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M svn $opt"
        fi
        ;;
    "telnet")
        echo "
        Available module options:
  MODE:? (NORMAL, AS400) [optional]
    Sets the mode for error detection."

        read -p "Enter opt (leave empty for default of NORMAL): " mode

        opt=""
        [[ -n "$mode" ]] && opt+="-m MODE:$mode "

        # Remove trailing space if exists
        opt="${opt% }"

        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M telnet "$opt")
            previous_command="medusa -h $target $combo_option $combo -M telnet $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M telnet "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M telnet $opt"
        fi
        ;;
    "vmauthd")
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M vmauthd)
            previous_command="medusa -h $target $combo_option $combo -M vmauthd"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M vmauthd)
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M vmauthd"
        fi
        ;;
    "vnc")
        echo "
        Available module options:
  MAXSLEEP:?
    Sets the maximum allowed sleep time when the VNC RealVNC anti-brute force delay
    is encountered. This value is in seconds and, if left unset, defaults to 60.
  DOMAIN:?
    Sets the domain value when authenticating against UltraVNC's MS-Logon feature.

Some versions of VNC have built-in anti-brute force functionality. RealVNC, for example,
allows 5 failed attempts and then enforces a 10 second delay. For each subsequent
attempt that delay is doubled. UltraVNC appears to allow 6 invalid attempts and then forces
a 10 second delay between each following attempt. This module attempts to identify these
situations and react appropriately by invoking sleep(). The user can set a sleep limit when
brute forcing RealVNC using the MAXSLEEP parameter. Once this value has been reached, the
module will exit.

It should be noted that this module currently supports password-less and password-only VNC
servers. In addition, it supports UltraVNC's MS-Logon feature that can be used to provide
pass-through authentication against local and domain Windows accounts. In the case of basic
password-only VNC, provide any arbitrary username value."

        read -p "Enter MAXSLEEP (leave empty for default of MAXSLEEP:60): " maxsleep
        read -p "Enter DOMAIN if UltraVNC (leave empty otherwise): " domain

        opt=""
        [[ -n "$maxsleep" ]] && opt+="-m MAXSLEEP:$maxsleep "
        [[ -n "$domain" ]] && opt+="-m DOMAIN:$domain "

        # Remove trailing space if exists
        opt="${opt% }"

        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M vnc "$opt")
            previous_command="medusa -h $target $combo_option $combo -M vnc $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M vnc "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M vnc $opt"
        fi
        ;;
    "web-form")
        echo "
        Available module options:
  USER-AGENT:?       User-agent value. Default: \"I'm not Mozilla, I'm Ming Mong\".
  FORM:?             Target form to request. Default: \"/\"
  DENY-SIGNAL:?      Authentication failure message. Attempt flagged as successful if text is not present in
                     server response. Default: \"Login incorrect\"
  CUSTOM-HEADER:?    Custom HTTP header.
                     More headers can be defined by using this option several times.
  FORM-DATA:<METHOD>?<FIELDS>
                     Methods and fields to send to web service. Valid methods are GET and POST. The actual form
                     data to be submitted should also be defined here. Specifically, the fields: username and
                     password. The username field must be the first, followed by the password field.
                     Default: \"post?username=&password=\""

        read -p "Enter USER-AGENT (leave empty for default of \"I'm not Mozilla, I'm Ming Mong\"): " user_agent
        read -p "Enter FORM (leave empty for default of \"/\"): " form
        read -p "Enter DENY-SIGNAL (leave empty for default of \"Login incorrect\"): " deny_signal
        read -p "Enter CUSTOM-HEADER (leave empty otherwise): " custom_header
        read -p "Enter FORM-DATA (leave empty for default of \"post?username=&password=\"): " form_data

        opt=""
        [[ -n "$user_agent" ]] && opt+="-m USER-AGENT:$user_agent "
        [[ -n "$form" ]] && opt+="-m FORM:$form "
        [[ -n "$deny_signal" ]] && opt+="-m DENY-SIGNAL:$deny_signal "
        [[ -n "$custom_header" ]] && opt+="-m CUSTOM-HEADER:$custom_header "
        [[ -n "$form_data" ]] && opt+="-m FORM-DATA:$form_data "

        # Remove trailing space if exists
        opt="${opt% }"
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M web-form "$opt")
            previous_command="medusa -h $target $combo_option $combo -M web-form $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M web-form "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M web-form $opt"
        fi
        ;;
    "wrapper")
        echo "
        Available module options:
  TYPE:? (SINGLE, STDIN)
    Option sets type of script being called by module. See included sample scripts
    for ideas how to use this module.

    SINGLE: Script expects all user input comes from original command line.
    STDIN:  Host and user information passed to script via command line.
            Passwords to test are passed via STDIN to script.

  PROG:?
    Option for setting path to executable file.

  ARGS:?
    Option for setting executable parameters. The following substitutions can be used:
    %H:  Replaced with target IP address.
    %U:  Replaced with username to test.
    %P:  Replaced with password to test.

    ---Usage example: '-M wrapper -m TYPE:SINGLE -m PROG:./foo.pl -m ARGS:\"-h %H -u %U -p %P\"'
Usage example: '-M wrapper -m TYPE:STDIN  -m PROG:./bar.pl -m ARGS:\"--host %H --user %U\"'---"

        read -p "Enter TYPE (leave empty for default of SINGLE): " type
        read -p "Enter PROG: " prog
        read -p "Enter ARGS: " args

        opt=""
        [[ -n "$type" ]] && opt+="-m TYPE:$type "
        [[ -n "$prog" ]] && opt+="-m PROG:$prog "
        [[ -n "$args" ]] && opt+="-m ARGS:\"$args\" "

        # Remove trailing space if exists
        opt="${opt% }"
        if [[ -n "$combo_option" ]]; then
            results=$(medusa -h "$target" "$combo_option" "$combo" -M wrapper "$opt")
            previous_command="medusa -h $target $combo_option $combo -M wrapper $opt"
        else
            results=$(medusa -h "$target" "$user_option" "$user" "$pass_option" "$pass" -M wrapper "$opt")
            previous_command="medusa -h $target $user_option $user $pass_option $pass -M wrapper $opt"
        fi
        ;;
    *)
        echo "Invalid module selected"
        ;;
    esac
    log_action "$previous_command"
    results

}

# Function to create CeWL wordlist
perform_cewl() {
    results=""
    desc="CEWL (pronounced cool) is a simple but effective tool used in cybersecurity and penetration testing. It stands for (Custom Word List generator). CEWL is designed to generate custom wordlists by spidering a target website and extracting unique words from it. These wordlists can then be used for various purposes, such as password cracking, dictionary attacks, or security testing.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "cewl"
    read -p "Enter url to create wordlist from (i.e. www.example.com): " target
    read -p "Minimum word length (default = 5): " min
    if [ -z "$min" ]; then
        min=5
    fi
    read -p "Spider Depth (default = 2): " depth
    if [ -z "$depth" ]; then
        depth=2
    fi
    read -p "Enter a name to save the CeWL list as: " name
    cewl "$target" -m "$min" -d "$depth" -w "wordlists/$name.txt"
    results=$(cat "wordlists/$name.txt")
    previous_command="cewl $target -m $min -d $depth -w wordlists/$name.txt"
    log_action "$previous_command"
    results

}

# Function to perform hash identifier
perform_hash_id() {
    results=""
    desc="Hash-ID is a command-line tool available in Kali Linux that helps identify the type of hash algorithm used to generate a given hash. This tool is handy for penetration testers, security analysts, and ethical hackers when they encounter a hash and need to determine which algorithm was used to create it.
    
    While Hash-ID can suggest possible hash types, it might not always be precise, especially if multiple hash types have similar patterns.
    
    ---Cheatsheet/Usage available in /cheatsheet---"
    show_description "hashid"
    read -p "Enter the Hash to identify: " hash
    python3 scripts/hashID.py "$hash" >hashes/ident.txt
    results=$(cat hashes/ident.txt)
    previous_command="python3 scripts/hashID.py $hash"
    log_action "$previous_command"
    results
}

############################ Fun zone
# Function to perform joker bomb
perform_joker_bomb() {
    clear
    splash "joker"

    # Get terminal dimensions
    rows=$(tput lines)
    cols=$(tput cols)

    while true; do
        # Generate random row and column
        row=$(shuf -i 4-"$((rows - 3))" -n 1)     # Adjusted to leave space at the bottom
        column=$(shuf -i 4-"$((cols - 10))" -n 1) # Adjusted to leave space at the right

        # Ensure column is not too close to the edge to avoid scrolling
        if ((column >= (cols - 9))); then
            ((column -= 9))
        fi

        color=$(shuf -i 0-255 -n 1)
        text=$(shuf -i 0-255 -n 1)

        # Move cursor to the generated position
        tput cup "$row" "$column"

        # Check if the row and column exceed the terminal size
        if ((row < rows && column < cols)); then
            # Print if within terminal dimensions
            echo -e "\e[48;5;${color}m\e[38;5;${text}mHahA\e[0m"
        fi

        sleep 0.0001 # Adjusted sleep duration for smoother animation
        read -t 0.1 -n 1 && break
    done
    clear
    display_menu
}
# Function to perform matrix effect modified from https://derrick.blog/2023/12/29/matrix-reimagined-crafting-digital-rain-with-bash-and-chatgpt/
perform_matrix() {
    clear
    echo -ne '\033[?25l'
    local msg="Wake up, Neo..."
    local msg2="The Matrix has you..."
    echo -e "\n\n\n${GREEN}"
    for ((i = 0; i < ${#msg}; i++)); do
        echo -n "${msg:$i:1}"
        sleep .1
    done
    sleep 4
    clear
    echo -e "\n\n\n"
    for ((i = 0; i < ${#msg2}; i++)); do
        echo -n "${msg2:$i:1}"
        sleep .1
    done
    sleep 4
    echo "${NC}"
    clear

    local extra_chars="ｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ"
    local extended_ascii="│┤┐└┴┬├─┼┘┌≡"

    # Define arrays of color codes for a fading green color effect, and a static color
    local fade_colors=('\033[38;2;0;255;0m' '\033[38;2;0;192;0m' '\033[38;2;0;128;0m' '\033[38;2;0;64;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;32;0m' '\033[38;2;0;16;0m' '\033[38;2;0;8;0m') # Fading green colors
    local static_color='\033[38;2;0;0;0m'                                                                                                                                                                                                                                                                                                                                                                                                                                         # Static dark green color
    local white_bold='\033[1;37m'                                                                                                                                                                                                                                                                                                                                                                                                                                                 # White and bold for the primary character

    # Get terminal dimensions
    local COLUMNS
    COLUMNS=$(tput cols) # Number of columns in the terminal
    local ROWS
    ROWS=$(tput lines) # Number of rows in the terminal

    # Hide the cursor for a cleaner effect and clear the screen
    echo -ne '\033[?25l'
    clear

    # Function to generate a random character from the set of extra characters and extended ASCII
    random_char() {
        local chars="${extra_chars}${extended_ascii}"
        echo -n "${chars:RANDOM%${#chars}:1}"
    }

    # Initialize arrays to keep track of the position and trail characters of each column
    local positions=()   # Array to store the current position in each column
    local trail_chars=() # Array to store the trail characters in each column
    for ((c = 1; c <= COLUMNS; c++)); do
        positions[$c]=$((RANDOM % ROWS)) # Random starting position for each column
        trail_chars[$c]=""               # Start with an empty trail for each column
    done

    # Main loop for continuous execution of the update_line function
    while true; do
        for ((c = 1; c <= COLUMNS; c++)); do
            # Randomly skip updating some columns to create a dynamic effect
            if [ $((RANDOM % 4)) -ne 0 ]; then
                continue
            fi

            local new_char
            new_char=$(random_char)        # Select a random character
            local pos=${positions[$c]}     # Current position in this column
            local trail=${trail_chars[$c]} # Current trail of characters in this column

            trail_chars[$c]="${new_char}${trail:0:$((ROWS - 1))}" # Update the trail by adding new character at the top

            # Render the trail of characters
            local last_pos=0
            for ((i = 0; i < ${#trail}; i++)); do
                local trail_pos=$((pos - i)) # Calculate the position for each character in the trail
                if [ $trail_pos -ge 0 ] && [ $trail_pos -lt $ROWS ]; then
                    local color=${fade_colors[i]:-$static_color} # Choose color from the fade array or static color if beyond the array
                    if [ $i -eq 0 ]; then
                        color=$white_bold # First character in the trail is white and bold
                    fi
                    if [ $last_pos -ne $trail_pos ]; then
                        printf "%b" "\033[${trail_pos};${c}H" # Move cursor to the right position
                        last_pos=$trail_pos
                    fi
                    printf "%b" "${color}${trail:$i:1}\033[0m" # Print the character with color
                fi
            done

            positions[$c]=$((pos + 1)) # Update the position for the next cycle
            if [ $pos -ge $((ROWS + ${#fade_colors[@]})) ]; then
                positions[$c]=0 # Reset position if it moves off screen
                trail_chars[$c]=""
            fi
        done
        read -t 0.0001 -n 1 && break
    done

    # Reset terminal settings on exit (show cursor, clear screen, reset text format)
    echo -ne '\033[?25h' # Show cursor
    clear
    tput sgr0 # Reset text format
}
# Function to perform clock "screensaver"
perform_clock() {
    while true; do
        clear

        # Generate random coordinates for clock position
        rows=$(tput lines)
        cols=$(tput cols)
        clock_row=$((RANDOM % (rows - 10) + 1)) # Ensure space for clock display
        clock_col=$((RANDOM % (cols - 25) + 1)) # Ensure space for clock display

        # Function to generate random ANSI color code (excluding black)
        generate_color() {
            local color=$((RANDOM % 255))
            while [ "$color" -eq 0 ]; do
                color=$((RANDOM % 255))
            done
            echo -e "\e[38;5;${color}m"
        }

        # Draw clock with random color
        tput cup $clock_row $clock_col
        echo -e "$(generate_color)╔═══════════════════════╗"
        tput cup $((clock_row + 1)) $clock_col
        echo -e "║     Current Time      ║"
        tput cup $((clock_row + 2)) $clock_col
        echo -e "╠═══════════════════════╣"
        tput cup $((clock_row + 3)) $clock_col
        echo -e "║      $(date +"%I:%M:%S %p")      ║"
        tput cup $((clock_row + 4)) $clock_col
        echo -e "╚═══════════════════════╝\e[0m"

        # Check for user input to return to the main menu
        read -t 0.1 -n 1 && break

        sleep 0.9 # Adjust the sleep time to maintain a total delay of 1 second
    done
}

# get the weather
perform_weather() {
    results=""
    desc="Check the weather in your area, without leaving your chair!"
    show_description "cloud"
    echo -e "\n${START}${RED}Press any key for the weather${NC}${END}"
    read -rsn1 key
    clear
    curl -s "http://wttr.in"
    previous_command="curl -s http://wttr.in"
    log_action "$previous_command"
    echo -e "\n${START}${RED}Press any key to go back${NC}${END}"
    read -rsn1 input
}

############################ End Fun Zone

############################ Workers
# Function to install missing tools
install_tools() {
    for tool in "${tools[@]}"; do
        if ! command -v $tool &>/dev/null; then
            echo "$tool is not installed. Installing..."
            sudo apt-get install -y $tool
        else
            echo "$tool is already installed."
        fi
    done
    sleep 5
}
splash() {
    keyword="$1"
    file="splash.txt"
    found=false

    # Check if the file exists
    if [ -f "$file" ]; then
        echo -e "${RED}"
        # Extract ASCII art based on keyword
        while IFS= read -r line; do
            if [[ "$line" =~ ^#BEGIN_.*[[:space:]]*"$keyword" ]]; then
                found=true

            elif [[ "$line" =~ ^#END_.*[[:space:]]*"$keyword" ]]; then
                found=false
            elif [ "$found" = true ]; then

                printf "%s\n" "$line"

            fi
        done <"$file"

    else
        echo "File $file not found."
    fi
    echo -e "${NC}"
}
# CTRL+C event handler
function on_ctrl_c() {
    clear
    echo # Set cursor to the next line of '^C'
    echo "Exiting..."
    tput cnorm # show cursor. You need this if animation is used.
    # i.e. clean-up code here
    exit 1 # Don't remove. Use a number (1-255) for error code.
}
# Save results
handle_save_results() {
    local target="$1"
    local datestamp
    datestamp=$(date +"%m-%d")
    local action=${FUNCNAME[2]//perform_/}

    # Remove "scan" from action if present
    if [[ "$action" == *"scan"* ]]; then
        action="${action//_scan/}"
    fi
    # Remove http:// or https:// from the target if present
    target_without_http="${target#*://}"
    target_without_slash="${target_without_http//\//-}"
    # Replace the second ":" with "-"
    target_formatted="${target_without_slash/:/-}"
    if [[ "$action" == *"gobuster"* ]] && [[ "$mode" == *"dir"* ]]; then
        local filename="${target_formatted}-${action}-dir-${datestamp}.txt"
    elif [[ "$action" == *"gobuster"* ]] && [[ "$mode" == *"dns"* ]]; then
        local filename="${target_formatted}-${action}-dns-${datestamp}.txt"
    elif [[ "$action" == *"gobuster"* ]] && [[ "$mode" == *"vhost"* ]]; then
        local filename="${target_formatted}-${action}-vhost-${datestamp}.txt"
    elif [[ "$action" == *"dotdotpwn"* ]] && [[ "$mode" == *"STDOUT"* ]]; then
        local filename="${action}-traversal-payload-${datestamp}.txt"
    elif [[ "$action" == *"harvest"* ]]; then
        local filename="${target_formatted}-${action}-${source}-${datestamp}.txt"
    elif [[ "$action" == *"medusa"* ]]; then
        local filename="${target_formatted}-${action}-${module}-${datestamp}.txt"
    else
        local filename="${target_formatted}-${action}-${datestamp}.txt"
    fi
    local folder="results"
    local filepath="$folder/$filename"

    read -p "Do you want to save the results? (y/n): " save_response
    if [[ $save_response =~ ^[Yy]$ ]]; then
        # Check if the file already exists
        if [ -e "$filepath" ]; then
            read -p "File '$filename' already exists. Do you want to overwrite it? (y/n): " overwrite_response
            if [[ ! $overwrite_response =~ ^[Yy]$ ]]; then
                echo -e "\n${START} ${RED}Results not saved. Press any key to go back${NC} ${END}"
                return
            fi
        fi

        # Create the results folder if it doesn't exist
        mkdir -p "$folder"
        # Add header to the file (target, action, and datestamp)
        {
            printf "Target: %s\n" "$target"
            printf "Action: %s\n" "$action"
            printf "Datestamp: %s\n" "$datestamp"
            printf "%.0s-" {1..40}
            printf "\n\n"
        } >"$filepath"
        # Save results to a file
        echo "$results" >>"$filepath"
        echo -e "\n${START} ${RED}Results saved to $filepath. Press any key to go back${NC} ${END}"
    else
        echo -e "\n${START} ${RED}Results not saved. Press any key to go back${NC} ${END}"
    fi
}
############################ End Workers

banner() {
    clear
    echo -ne '\033[?25l'
    splash "syn"
    echo
    echo
    # Fancy loading progress bar
    for ((i = 1; i <= 59; i++)); do
        echo -ne '                                      LOADING...  ['
        for ((j = 1; j <= i; j++)); do
            case $((j % 7)) in
            1) echo -ne '\e[31m⣀\e[0m' ;;
            2) echo -ne '\e[33m⣤\e[0m' ;;
            3) echo -ne '\e[32m⣶\e[0m' ;;
            4) echo -ne '\e[36m⣿\e[0m' ;;
            5) echo -ne '\e[34m⣿\e[0m' ;;
            6) echo -ne '\e[35m⣶\e[0m' ;;
            0) echo -ne '\e[31m⣤\e[0m' ;;
            esac
        done

        for ((k = i + 1; k <= 59; k++)); do
            echo -ne ' '
        done
        echo -ne '] (\e[31m'$((i * 100 / 59))'%\e[0m)\r'
        sleep 0.05
    done
    sleep 2
}
if [ "$1" = "--noshow" ]; then
    :
else
    banner
fi

############################ Main loop
while true; do
    display_menu
    handle_input
done
