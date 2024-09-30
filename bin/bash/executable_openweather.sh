#!/bin/sh

CACHE_FILE="/tmp/weather_cache.json"
STATE_FILE="/tmp/weather_state.txt"
CACHE_TIME=3600  # Cache for 1 hour in seconds
# Fetch the API key from the file
KEY=$(cat ~/bin/api/weather_api_key)
CITY="Reykjavik"
UNITS="metric"
SYMBOL="°"
# Function to get the appropriate icon based on weather code
get_icon() {
    case $1 in
        01d) icon="";;
        01n) icon="";;
        02d) icon="";;
        02n) icon="";;
        03*) icon="";;
        04*) icon="";;
        09d) icon="";;
        09n) icon="";;
        10d) icon="";;
        10n) icon="";;
        11d) icon="";;
        11n) icon="";;
        13d) icon="";;
        13n) icon="";;
        50d) icon="";;
        50n) icon="";;
        *) icon="";
    esac

    echo $icon
}

# Function to fetch weather data
fetch_weather() {
    API="https://api.openweathermap.org/data/2.5/weather?appid=$KEY&q=$CITY&units=$UNITS"
    curl -sf "$API" > "$CACHE_FILE"
}


# Check if cache file exists, is empty, or is older than the cache time
if [ ! -f "$CACHE_FILE" ] || [ ! -s "$CACHE_FILE" ] || [ $(( $(date +%s) - $(stat -c %Y "$CACHE_FILE") )) -gt $CACHE_TIME ]; then
    fetch_weather
fi

# Read from cache file
if [ -f "$CACHE_FILE" ]; then
    current=$(cat "$CACHE_FILE")
    
    # Extract relevant information
    current_temp=$(echo "$current" | jq ".main.temp" | cut -d "." -f 1)
    current_icon=$(echo "$current" | jq -r ".weather[0].icon")
    current_wind_speed=$(echo "$current" | jq ".wind.speed" | cut -d "." -f 1)

    # Check the current state
    if [ -f "$STATE_FILE" ]; then
        state=$(cat "$STATE_FILE")
    else
        state="collapsed"  # Default state if the state file doesn't exist
    fi

    # Handle the toggle action
    if [ "$1" = "toggle" ]; then
        if [ "$state" = "collapsed" ]; then
            echo "expanded" > "$STATE_FILE"
            state="expanded"
        else
            echo "collapsed" > "$STATE_FILE"
            state="collapsed"
        fi
    fi

    # Output based on the current state
    if [ "$state" = "expanded" ]; then
        echo "$(get_icon "$current_icon") $current_temp$SYMBOL  $current_wind_speed m/s"
    else
        echo ""  # Default icon for collapsed state
    fi
else
    echo "Error fetching weather data"
fi


