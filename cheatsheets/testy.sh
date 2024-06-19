#!/bin/bash
display_with_frame() {
    local file="$1"
    local line_length="$2"
    local page_size="$3"
    RED='\e[31m'
    BLUE='\e[34m'
    NC='\e[0m'

    if [[ ! -f "$file" ]]; then
        echo "File not found!"
        return 1
    fi

    # Read file content
    content=$(cat "$file")
    # content=$(pdftotext "$file" - | less)

    # Remove control characters and ANSI color codes, replace tabs with spaces
    clean_content=$(echo "$content" | sed -r 's/\x1B\[[0-9;]*[mK]//g' | tr -d '\r' | expand)

    # Wrap lines to the specified length
    wrapped_content=$(echo "$clean_content" | fold -s -w "$line_length")

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
██                                                                                                               ██${NC}"

frame_line_end="${BLUE}██                                                                                                               ██                                           
██                                                                                                               ██                                           
 █                                                                                                               █                                           
 ██                                                                                                             ██                                            
   ███                                                                                                       ███                                              
     █████████████████████████████████████████████████████████████████████████████████████████████████████████ ${NC}"
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
    current_line=1

    while [ "$current_line" -le "$total_lines" ]; do
        page_content=$(echo "$wrapped_content" | sed -n "${current_line},$((current_line + page_size - 1))p")
        clear
        echo "$page_content" | add_frame
        current_line=$((current_line + page_size))
        if [ "$current_line" -le "$total_lines" ]; then
            echo -e "\nPress any key to continue to the next page, or \"Q\" to exit."
            read -s -n 1 key
            if [[ $key == 'q' ]]; then
                echo "Exiting..."
                break
            fi
        fi
    done
}

# Usage
# display_with_frame <file_path> <line_length> <page_size>
display_with_frame "SQL_Cheat_Sheet.pdf" 109 20
