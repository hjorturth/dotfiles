#!/bin/bash
# fetch_key.sh

# Login to Bitwarden and get the session if not already done
if [[ -z "$BW_SESSION" ]]; then
    export BW_SESSION=$(bw login --raw)
fi

# Fetch the encryption key from Bitwarden
bw get item <item_id> --session "$BW_SESSION" | jq -r '.notes'
