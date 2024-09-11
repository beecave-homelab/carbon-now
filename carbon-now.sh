#!/bin/bash
set -euo pipefail

# ------------------------------------------
# Script: carbon-url-builder.sh
# Description: Generates a Carbon Now URL for creating code snippet images.
# Author: [Your Name]
# Version: 1.4.0
# License: MIT
# Creation Date: [dd/mm/yyyy]
# Last Modified: [dd/mm/yyyy]
# Usage: ./carbon-url-builder.sh [OPTIONS]
# ------------------------------------------

# Constants
DEFAULT_BG="rgba(0, 0, 0, 1)"
DEFAULT_FONT="Fira Code"
DEFAULT_SIZE="15px"
DEFAULT_THEME="one-light"
DEFAULT_EXPORT_SIZE="4x"
DEFAULT_PADDING_VERTICAL="0px"
DEFAULT_PADDING_HORIZONTAL="0px"
DEFAULT_LINE_HEIGHT="133%"
DEFAULT_LINE_NUMBERS=false
DEFAULT_WATERMARK=false
DEFAULT_WINDOW_THEME="none"

# Function to display ASCII art
ascii_art() {
    echo ""
    echo " ██████  █████  ██████  ██████   ██████  ███    ██ "
    echo "██      ██   ██ ██   ██ ██   ██ ██    ██ ████   ██ "
    echo "██      ███████ ██████  ██████  ██    ██ ██ ██  ██ "
    echo "██      ██   ██ ██   ██ ██   ██ ██    ██ ██  ██ ██ "
    echo " ██████ ██   ██ ██   ██ ██████   ██████  ██   ████ "
    echo "                                                   "
    echo "                                                   "
    echo "  ███    ██  ██████  ██     ██    ███████ ██   ██    "
    echo "  ████   ██ ██    ██ ██     ██    ██      ██   ██    "
    echo "  ██ ██  ██ ██    ██ ██  █  ██    ███████ ███████    "
    echo "  ██  ██ ██ ██    ██ ██ ███ ██         ██ ██   ██    "
    echo "  ██   ████  ██████   ███ ███  ██ ███████ ██   ██    "
    echo "                                                   "
    echo "                                                   "
}

# Function to display help information
show_info() {
    ascii_art
    echo
    echo "Usage: carbon-url-builder.sh [OPTIONS]"
    echo
    echo "Options:"
    echo "  -i, --input    - A string representing the code snippet or a path to a file containing the code."
    echo "  -c, --config   - Optional JSON file to configure the URL parameters."
    echo "  -e, --embed    - Generate an embedding URL for the generated Carbon Now URL (optional)."
    echo "  -h, --help     - Display this help message."
    echo
    echo "Default Values (can be overridden by the JSON config file or user input):"
    echo "  Background Color    : $DEFAULT_BG"
    echo "  Padding Vertical    : $DEFAULT_PADDING_VERTICAL"
    echo "  Padding Horizontal  : $DEFAULT_PADDING_HORIZONTAL"
    echo "  Theme               : $DEFAULT_THEME"
    echo "  Font Family         : $DEFAULT_FONT"
    echo "  Font Size           : $DEFAULT_SIZE"
    echo "  Line Height         : $DEFAULT_LINE_HEIGHT"
    echo "  Line Numbers        : $DEFAULT_LINE_NUMBERS"
    echo "  Export Size         : $DEFAULT_EXPORT_SIZE"
    echo "  Watermark           : $DEFAULT_WATERMARK"
    echo "  Window Theme        : $DEFAULT_WINDOW_THEME"
    echo
    echo "Examples:"
    echo "  ./carbon-url-builder.sh -i 'print(\"Hello, World!\")' -e"
    echo "  ./carbon-url-builder.sh --input /path/to/code.py --config config.json"
}

# Function to URL encode a given input
url_encode() {
    local data="$1"
    echo -n "$data" | jq -s -R -r @uri
}

# Function to parse the JSON config file
parse_json_config() {
    local config_file="$1"
    
    padding_vertical=$(jq -r '.paddingVertical // "0px"' "$config_file")
    padding_horizontal=$(jq -r '.paddingHorizontal // "0px"' "$config_file")
    background_color=$(jq -r '.backgroundColor // "rgba(0, 0, 0, 1)"' "$config_file")
    theme=$(jq -r '.theme // "one-light"' "$config_file")
    font_family=$(jq -r '.fontFamily // "Fira Code"' "$config_file")
    font_size=$(jq -r '.fontSize // "15px"' "$config_file")
    line_height=$(jq -r '.lineHeight // "133%"' "$config_file")
    line_numbers=$(jq -r '.lineNumbers // false' "$config_file")
    export_size=$(jq -r '.exportSize // "4x"' "$config_file")
    watermark=$(jq -r '.watermark // false' "$config_file")
    window_theme=$(jq -r '.windowTheme // "none"' "$config_file")
}

# Function to build the Carbon URL
build_url() {
    local code="$1"
    local lines_to_highlight="$2"
    local background_color="$3"
    local font_family="$4"
    local font_size="$5"
    local theme="$6"
    
    # URL encode the code and other parameters
    encoded_code=$(url_encode "$code")
    encoded_font_family=$(url_encode("$font_family"))
    encoded_theme=$(url_encode("$theme"))

    # Base Carbon URL with customizable parameters
    local base_url="https://carbon.now.sh/"
    local full_url="${base_url}?bg=${background_color}&code=${encoded_code}&ds=false&dsblur=68px&dsyoff=20px&es=${export_size}&fm=${encoded_font_family}&fs=${font_size}&highlight=true&l=auto&ln=${line_numbers}&ph=${padding_horizontal}&pv=${padding_vertical}&save=false&si=false&sl=${lines_to_highlight}&t=${encoded_theme}&type=png&wa=true&wc=false&wm=${watermark}&wt=${window_theme}"

    echo "Generated Carbon URL:"
    echo "$full_url"

    # Ask the user if they want to copy to clipboard or open the URL in a browser
    read -p "Would you like to (c)opy the URL to clipboard or (o)pen in browser? (c/o): " action_choice
    if [[ "$action_choice" == "o" ]]; then
        if command -v xdg-open &> /dev/null; then
            xdg-open "$full_url"
        elif command -v open &> /dev/null; then
            open "$full_url"
        else
            echo "Error: Could not open the URL. Please open it manually." >&2
        fi
    elif [[ "$action_choice" == "c" ]]; then
        if command -v xclip &> /dev/null; then
            echo -n "$full_url" | xclip -selection clipboard
            echo "URL copied to clipboard."
        else
            echo "Error: xclip is not installed. Please copy the URL manually."
        fi
    fi

    # Return the generated URL for further processing if needed
    echo "$full_url"
}

# Function to generate embedding URL
generate_embedding_url() {
    local full_url="$1"
    # Replace the base URL with the embedding URL base
    local embed_url="${full_url/https:\/\/carbon.now.sh/https:\/\/carbon.now.sh\/embed\/:}"

    echo "Generated Embedding URL:"
    echo "$embed_url"

    # Ask the user if they want to copy to clipboard or open the URL in a browser
    read -p "Would you like to (c)opy the embedding URL to clipboard or (o)pen in browser? (c/o): " embed_action_choice
    if [[ "$embed_action_choice" == "o" ]]; then
        if command -v xdg-open &> /dev/null; then
            xdg-open "$embed_url"
        elif command -v open &> /dev/null; then
            open "$embed_url"
        else
            echo "Error: Could not open the embedding URL. Please open it manually." >&2
        fi
    elif [[ "$embed_action_choice" == "c" ]]; then
        if command -v xclip &> /dev/null; then
            echo -n "$embed_url" | xclip -selection clipboard
            echo "Embedding URL copied to clipboard."
        else
            echo "Error: xclip is not installed. Please copy the embedding URL manually."
        fi
    fi
}

# Main function
main() {
    local code=""
    local config_file=""
    local embedding_flag=false

    # Parse command-line arguments
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -i|--input)
                if [[ -f "$2" ]]; then
                    code=$(cat "$2")
                else
                    code="$2"
                fi
                shift 2
                ;;
            -c|--config)
                config_file="$2"
                shift 2
                ;;
            -e|--embed)
                embedding_flag=true
                shift
                ;;
            -h|--help)
                show_info
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_info
                exit 1
                ;;
        esac
    done

    # Ensure code input is provided
    if [[ -z "$code" ]]; then
        echo "Error: No code snippet or file provided." >&2
        show_info
        exit 1
    fi

    # If config file is provided, parse it
    if [[ -n "$config_file" ]]; then
        if [[ -f "$config_file" && -r "$config_file" ]]; then
            parse_json_config "$config_file"
        else
            echo "Error: Cannot read config file '$config_file'." >&2
            show_info
            exit 1
        fi
    else
        # Use default values if no config file is provided
        padding_vertical="$DEFAULT_PADDING_VERTICAL"
        padding_horizontal="$DEFAULT_PADDING_HORIZONTAL"
        background_color="$DEFAULT_BG"
        font_family="$DEFAULT_FONT"
        font_size="$DEFAULT_SIZE"
        theme="$DEFAULT_THEME"
        line_height="$DEFAULT_LINE_HEIGHT"
        line_numbers="$DEFAULT_LINE_NUMBERS"
        export_size="$DEFAULT_EXPORT_SIZE"
        watermark="$DEFAULT_WATERMARK"
        window_theme="$DEFAULT_WINDOW_THEME"
    fi

    # Get additional customizations
    read -p "Enter comma-separated line numbers to highlight (e.g., 2,3,4): " lines_to_highlight

    # Build and display the Carbon URL
    full_url=$(build_url "$code" "$lines_to_highlight" "$background_color" "$font_family" "$font_size" "$theme")

    # If embedding flag is set, generate the embedding URL
    if [[ "$embedding_flag" == true ]]; then
        generate_embedding_url "$full_url"
    fi
}

# Invoke the main function
main "$@"