#!/bin/bash
# Created by Psiber_Syn
# Function to display colored error box
show_error() {
    local message="$1"
    local color_red=$(tput setaf 1)
    local bold=$(tput bold)
    local color_reset=$(tput sgr0)
    local box_width=$(( ${#message} + 5 ))

    # Print error message in red color within a yellow box
    echo -e "${bold}${color_red}"
    printf '=%.0s' $(seq 1 $box_width)
    printf "\n= ERROR%*s=\n" $((box_width - 8)) ""
    printf '=%.0s' $(seq 1 $box_width)
    echo -e "\n= ${message}  ="
    printf '=%.0s' $(seq 1 $box_width)
    echo -e "${color_reset}"
}

# Function LOTL
LOTL() {
    # Check if a binary name is provided and if it contains only alphanumeric characters, underscores, and hyphens
    if [ -z "$1" ] || [[ ! "$1" =~ ^[a-zA-Z0-9_-]+$ ]]; then
        clear
        show_error "Valid binary name containing only [a-zA-Z0-9_-]."
        return 1
    fi

    # Splash Screen
    clear
    echo -e "\e[32m                                                  :J5.
                                                :5&@@7  .:.
                             ..              !&@#Y77JPB&@?
                       7Y~.  7B&!             ~@@@GG&@&#BG#~
                     .&@@~.P@@BY.          .#@@@@@@&PJ7~.
                      :&@P.B@B!!~            :J??JY5PB&@@5
                       5@#B@@5G@@Y         .        .~7    ^YJ^
   ::                 .P@@@@&G?~. .:!?YPGB###BBG5J7^.   !P@@@@BJ^
.Y&&5~                 !PG7.   ^?P#@@@@@@@@@@@@@@@@@&GYJB@@&5P&@@@BY~.
.7B@@@G?:                   :!5#@@@@@@@@@@@@@@@@@@@@@@@@@@@P~..~5&@@@@#5!:
    ~P&@@&G?^.           :~JG&@@@@@@&B5J!~^:::^!?5B&@@@@@@@@@@&&&&@@@@@@@@&G?.
      :?G@@@@#G5J7!!7?JPB&@@@@@@&GJ!:    .::..    :75&@@@@@BPP5PG@@@@@@@&GJ^
         ^7P#@@@@@@@@@@@@@@&BP?~.    ^75B#&&@@&B?    .7G@@@G!..7G@@@@#5!:
           .:!?Y5PGGGP5J7~:       .G@@@@&5JYBJ.        ^Y&@@#&@@@BY~.
                        ..          :B@@#&@&P?.          .?B@@BJ^
                 5#BGGGB#@B           ~@@B^7#@@&Y:           !^
                 G@@@@@BY?7          .#@@J.P#5?:
                ?@@YJG@&BP57          ^~!~
                  5@@P^^?P&@!
                   7B?.  .

                                                 \e[0m\e[31m╔$(printf '═%.0s' {1..22})╗
                                                 ║       AX.o.LOTL      ║
                                                 ║   Living Of The Land ║
                                                 ╚$(printf '═%.0s' {1..22})╝\e[0m\n"

    # Fancy loading progress bar
    for ((i=1; i<=29; i++)); do
        echo -ne '                 ['
        for ((j=1; j<=i; j++)); do
            case $((j % 7)) in
                1) echo -ne '\e[31m⣀\e[0m';;
                2) echo -ne '\e[33m⣤\e[0m';;
                3) echo -ne '\e[32m⣶\e[0m';;
                4) echo -ne '\e[36m⣿\e[0m';;
                5) echo -ne '\e[34m⣿\e[0m';;
                6) echo -ne '\e[35m⣶\e[0m';;
                0) echo -ne '\e[31m⣤\e[0m';;
            esac
        done

        for ((k=i+1; k<=29; k++)); do
            echo -ne ' '
        done
        echo -ne '] (\e[31m'$((i*3+13))'%\e[0m)\r'
        sleep 0.05
    done
    sleep 2

    local binary="$1"
    local url=""

    # Check if -w or -l argument is provided
    if [ "$2" == "-l" ]; then
        url="https://gtfobins.github.io/gtfobins/$binary/"
    elif [ "$2" == "-w" ]; then
        url="https://lolbas-project.github.io/lolbas/Binaries/$binary/"
    else
        clear
        show_error "Invalid argument [-w] for Windows or [-l] For Linux Binaries."
        return 1
    fi

    # Query url for the binary
    local response=$(curl -s "$url")

    # Extract the list of functions
    local functions=$(echo "$response" | pup 'h2.function-name text{}' | sed 's/^\s*//;s/\s*$//' | sed '/^$/d')  # Remove leading/trailing spaces and empty lines

    # Check if there are any functions available
    if [ -z "$functions" ]; then
        clear
        show_error "'$binary' not found in database."
        return 1
    fi

    local i=1
    local function_array=()

    while IFS= read -r func; do
        function_array+=("$func")
        ((i++))
    done <<< "$functions"

    # Prompt for function selection
    local selected_index=0
    while true; do
        # Clear the screen
        clear
        printf "   \e[1;44m╔$(printf '═%.0s' {1..69})╗\e[0m\n"
        binary_length=$(echo -n $binary | wc -c)
        padding=$((52 - binary_length))
        printf "   \e[1;44m║                   \e[0m\e[1;4;44;31mAX.o.LOTL\e[0m\e[1;44;36m - Living Off The Land\e[0m\e[1;44m                   ║\e[0m\n"
        printf "   \e[1;44m╠$(printf '═%.0s' {1..69})\e[1;44m╣\e[0m\n"
        printf "   \e[1;44m║    Exploits for \e[0m\e[1;44;31m%s\e[0m\e[1;44m%*s\e[0m\e[1;44m║\e[0m\n" "$binary" $padding ""
        printf "   \e[1;44m╠$(printf '═%.0s' {1..69})\e[1;44m╣\e[0m\n"
        printf "   \e[1;44m║\e[0m                                                                     \e[1;44m║\e[0m\n"

        # Print the function list with the current selection highlighted
        for ((j=0; j<${#function_array[@]}; j++)); do
            if [ $j -eq $selected_index ]; then
                printf "   \e[1;44m║\e[0m   \e[46m[$(($j+1))]\e[0m. \e[4;36m${function_array[j]}\e[0m%*s\e[1;44m║\e[0m\n" $((${#function_array[j]}-61)) " "
            else
                printf "   \e[1;44m║\e[0m   \e[44m[$(($j+1))]\e[0m. \e[36m${function_array[j]}\e[0m%*s\e[1;44m║\e[0m\n" $((${#function_array[j]}-61)) " "
            fi
        done

        # Navigation instructions and copyright
        printf "   \e[1;44m║\e[0m$(printf ' %.0s' {1..69})\e[1;44m║\e[0m\n"
        echo -e "   \e[1;44m╠$(printf '═%.0s' {1..69})╣\e[0m"
        echo -e "   \e[1;44m║   \e[0m\e[1;44m\e[1;46m[⇧/⇩]\e[0m\e[1;44m + \e[0m\e[1;46m[enter]\e[0m\e[1;44m to select                      \e[0m\e[1;44;36m\e[1;36m© 2024 Psiber Syn \e[0m\e[1;44m ║\e[0m"
        echo -e "   \e[1;44m╚$(printf '═%.0s' {1..69})╝\e[0m"
        # Read a single key input
        read -rsn1 key

        # Handle arrow key inputs
        case "$key" in
            "A") # Up arrow
                if [ $selected_index -gt 0 ]; then
                    ((selected_index--))
                elif [ $selected_index -eq 0 ]; then
                    selected_index=$((${#function_array[@]}-1))
                fi
                ;;
            "B") # Down arrow
                if [ $selected_index -lt $((${#function_array[@]}-1)) ]; then
                    ((selected_index++))
                elif [ $selected_index -eq $((${#function_array[@]}-1)) ]; then
                    selected_index=0
                fi
                ;;
            "") # Enter key
                break
                ;;
        esac
    done

    # Retrieve the exploit code for the chosen function
    local chosen_func=$(echo "${function_array[selected_index]}" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
    local exploit=$(echo "$response" | awk -v chosen_func="$chosen_func" '/<h2 id="'$chosen_func'"/,/<\/pre>/ {gsub(/<\/?[^>]+>/, ""); gsub(/&lt;/, "<"); gsub(/&gt;/, ">"); gsub(/&amp;/, "\\x26"); gsub(/&quot;/, "\""); gsub(/&#39;/, "\x27"); sub(/^[[:space:]]+/, ""); if ($0 ~ /\S/) print $0;}')

    # Check if exploit code is empty
    if [ -z "$exploit" ]; then
        show_error "No exploit code found"
        return 1
    fi

    # Display the chosen function and its exploit code
    if [ -n "$exploit" ]; then
        formatted_results=$(echo "$exploit" | fold -w 66 -s | awk '{ printf "   \033[1m\033[34m║\033[0m%-69s\033[1m\033[34m║\033[0m\n", $0 }')
        printf "\033[1m\033[34m   ╔$(printf '═%.0s' {1..69})╗\n\033[0m"
        printf "\033[1m\033[34m   ║ \033[1m\e[31mResults: \033[0m$(printf ' %.0s' {1..59})\033[1m\033[34m║\n\033[0m"
        printf "\033[1m\033[34m   ╠$(printf '═%.0s' {1..69})╣\n\033[0m"
        printf "%s\n" "$formatted_results"
        printf "\033[1m\033[34m   ╚$(printf '═%.0s' {1..69})╝\n\033[0m"
    fi
}

    # Check if the script is being sourced or executed
    if [[ "$0" == "$BASH_SOURCE" ]]; then
    # Script is being executed, call the LoL function with arguments
    LOTL "$@"
    fi
