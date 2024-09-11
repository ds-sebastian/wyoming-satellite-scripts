#!/bin/bash

# Define the repository name
REPO_NAME="dreed47"

# Load menu functions
source <(curl -s https://raw.githubusercontent.com/$REPO_NAME/wyoming-satellite-scripts/$WYOMING_SATELLITE_SCRIPT_RELEASE/scripts/menu_functions.sh)

# Define the menu options and their corresponding commands
declare -A options
options=(
    ["Select Wakeword"]="bash -c \"$(wget -qLO - https://github.com/$REPO_NAME/wyoming-satellite-scripts/raw/$WYOMING_SATELLITE_SCRIPT_RELEASE/scripts/select-wakeword.sh)\""
    ["Show current Wakeword"]="bash -c \"$(wget -qLO - https://github.com/$REPO_NAME/wyoming-satellite-scripts/raw/$WYOMING_SATELLITE_SCRIPT_RELEASE/scripts/show-wakeword.sh)\""
    ["Refresh Wakeword list"]="bash -c \"$(wget -qLO - https://github.com/$REPO_NAME/wyoming-satellite-scripts/raw/$WYOMING_SATELLITE_SCRIPT_RELEASE/scripts/refresh-wakeword-list.sh)\""
    ["Install PulseAudio and Snapclient"]="bash -c \"$(wget -qLO - https://github.com/$REPO_NAME/wyoming-satellite-scripts/raw/$WYOMING_SATELLITE_SCRIPT_RELEASE/scripts/install_pulseaudio_snapclient.sh)\""
    ["Enable PulseAudio and Snapclient Enhancements"]="bash -c \"$(wget -qLO - https://github.com/$REPO_NAME/wyoming-satellite-scripts/raw/$WYOMING_SATELLITE_SCRIPT_RELEASE/scripts/enable_enhancements.sh)\""
    ["Disable PulseAudio and Snapclient Enhancements"]="bash -c \"$(wget -qLO - https://github.com/$REPO_NAME/wyoming-satellite-scripts/raw/$WYOMING_SATELLITE_SCRIPT_RELEASE/scripts/disable_enhancements.sh)\""
    ["Edit wyoming-satellite service file"]='sudo systemctl edit --force --full wyoming-satellite.service'
    ["Edit wyoming-wakeword service file"]='sudo systemctl edit --force --full wyoming-openwakeword.service'
    ["Edit 2mic_leds service file"]='sudo systemctl edit --force --full 2mic_leds.service'
    ["Edit the pulse audio service file"]='sudo systemctl edit --force --full pulseaudio.service'
    ["Update service files from github"]="bash -c \"$(wget -qLO - https://github.com/$REPO_NAME/wyoming-satellite-scripts/raw/$WYOMING_SATELLITE_SCRIPT_RELEASE/scripts/update-service-files.sh)\""
    ["Reload all services"]="bash -c \"$(wget -qLO - https://github.com/$REPO_NAME/wyoming-satellite-scripts/raw/$WYOMING_SATELLITE_SCRIPT_RELEASE/scripts/service-reload.sh)\""
    ["Tail Wyoming Log"]='tail -f /var/log/wyoming.log'
    ["Tail Wakeword Log"]='tail -f /var/log/wakeword.log'
    ["Examine Disk Space"]='sudo ncdu /'
    ["Reboot"]='sudo reboot'
)

# Array of option labels, including the Quit option
option_labels=(
    "Select Wakeword"
    "Show current Wakeword"
    "Refresh Wakeword list"
    "Install PulseAudio and Snapclient"
    "Enable PulseAudio and Snapclient Enhancements"
    "Disable PulseAudio and Snapclient Enhancements"
    "Edit wyoming-satellite service file"
    "Edit wyoming-wakeword service file"
    "Edit 2mic_leds service file"
    "Update service files from github"
    "Reload all services"
    "Tail Wyoming Log"
    "Tail Wakeword Log"
    "Examine Disk Space"
    "Reboot"
    "Quit")

# Call the main menu function
main_menu