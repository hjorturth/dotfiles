#!/bin/bash

# Directory containing your theme files
THEME_DIR="$HOME/.config/polybar/themes"
# Rofi command to select theme
THEME=$(ls $THEME_DIR | rofi -dmenu -p "Select Theme:")

# Check if a theme was selected
if [[ -n "$THEME" ]]; then
    # Path to the selected theme file
    SELECTED_THEME="$THEME_DIR/$THEME"

    # Set the theme (you might want to source it, or copy it to a specific config file)
    cp "$SELECTED_THEME" "$HOME/.config/polybar/colors"  # Adjust this path as needed

    # Restart Polybar
    killall polybar
    polybar your_bar_name &  # Replace `your_bar_name` with the actual name of your bar
fi

