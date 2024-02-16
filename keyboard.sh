#!/bin/bash
#######################################
# Enables or disables laptop keyboard #
#######################################

# Keyboard name to work with
KB_NAME="AT Translated Set 2 keyboard"

# Grab keyboard ID
KB_ID=$(xinput list | grep "$KB_NAME" | awk '{ print $7 }' | sed -r 's/id=//g')

# Check if the keyboard is floating (disabled)
KB_IS_DISABLED=$(xinput list --long | grep "∼ $KB_NAME" | grep -o 'floating')

# If the keyboard is floating, find an appropriate slave keyboard to reattach
if [ ! -z "$KB_IS_DISABLED" ]; then
    # Find the first slave keyboard that is not the laptop's keyboard
    KB_SLAVE_ID=$(xinput list | grep 'slave  keyboard' | grep -v "$KB_NAME" | awk -F"[()]" 'NR==1{ print $2 }')
    
    if [ ! -z "$KB_SLAVE_ID" ]; then
        xinput reattach "$KB_ID" "$KB_SLAVE_ID"
        echo "Keyboard enabled."
    else
        echo "No slave keyboard found to reattach."
    fi
else
    # Disable the keyboard by floating it
    xinput float "$KB_ID"
    echo "Keyboard disabled."
fi

