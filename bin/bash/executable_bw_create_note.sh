#!/bin/bash

# Function to display help
show_help() {
    echo "Usage: $0 --name \"note-name\" --notes \"your note contents\""
}

# Parse input arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --name) NOTE_NAME="$2"; shift ;;
        --notes) NOTE_CONTENT="$2"; shift ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; show_help; exit 1 ;;
    esac
    shift
done

# Check if both name and notes are provided
if [ -z "$NOTE_NAME" ] || [ -z "$NOTE_CONTENT" ]; then
    echo "Error: --name and --notes arguments are required."
    show_help
    exit 1
fi

# Ensure Bitwarden session is active
if ! bw status | grep -q "unlocked"; then
    echo "Error: Bitwarden is not unlocked. Please login or unlock the vault first."
    exit 1
fi

# Create the secure note using the Bitwarden CLI
bw get template item | \
jq --arg name "$NOTE_NAME" --arg notes "$NOTE_CONTENT" \
'.type = 2 | .secureNote.type = 0 | .notes = $notes | .name = $name' | \
bw encode | \
bw create item

# Check if creation was successful
if [ $? -eq 0 ]; then
    echo "Secure note '$NOTE_NAME' created successfully."
else
    echo "Failed to create the secure note."
    exit 1
fi
