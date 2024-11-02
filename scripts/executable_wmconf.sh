#!/bin/bash

# ANSI color codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[0;33m'
readonly BLUE='\033[0;34m'
readonly RESET='\033[0m'  # Reset color

# Base directory for configuration files
readonly CONFIG_DIR="$HOME/.config"

# Function to print colored messages
print_color() {
    local color="$1"
    local message="$2"
    echo -e "${color}${message}${RESET}"
}

# Print colored prompts
print_color $BLUE "Which file do you want to open with vi?"
print_color $YELLOW "1) yabairc"
print_color $YELLOW "2) skhdrc"
print_color $YELLOW "3) borderssrc"
print_color $YELLOW "4) sketchybarrc"

# Read user input
read -p "$(print_color $GREEN 'Enter a number: ')" choice

# Handle user input
case $choice in
    1)
        config_file="$CONFIG_DIR/yabai/yabairc"
        ;;
    2)
        config_file="$CONFIG_DIR/skhd/skhdrc"
        ;;
    3)
        config_file="$CONFIG_DIR/borders/bordersrc"
        ;;
    4)
        config_file="$CONFIG_DIR/sketchybar/sketchybarrc"
        ;;
    *)
        print_color $RED "Invalid choice. Please enter 1, 2, 3, or 4."
        exit 1
        ;;
esac

# Open the selected config file with vi if valid choice was made
if [[ -n $config_file && -f $config_file ]]; then
    print_color $GREEN "Opening $config_file with vi..."
    # vi $config_file
    $EDITOR $config_file
else
    print_color $RED "Error: Configuration file not found or invalid."
fi

