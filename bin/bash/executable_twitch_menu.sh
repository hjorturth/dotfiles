#!/bin/bash

# Define the options
options=("Hasanabi" "Struggle4" "Central_Committee" "Hannah")

# Display the menu using Rofi
selected_option=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "Choose an option:")

# Check if the selected option is empty (user presses Esc)
if [[ -z "$selected_option" ]]; then
    exit 1
fi

# Open the stream with streamlink, whether the option is predefined or custom
streamlink "twitch.tv/$selected_option" -Q &
