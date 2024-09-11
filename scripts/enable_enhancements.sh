#!/usr/bin/env bash

# Define colors for status messages
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Check if PulseAudio and Snapclient are installed
if ! command -v pulseaudio &> /dev/null || ! command -v snapclient &> /dev/null
then
    echo "${RED}PulseAudio or Snapclient is not installed. Please run install_pulseaudio_snapclient.sh first.${RESET}"
    exit 1
fi

echo "${YELLOW}Enabling PulseAudio and Snapclient enhancements...${RESET}"

# Modify Wyoming Satellite service
WYOMING_SERVICE="/etc/systemd/system/wyoming-satellite.service"

# Update mic and sound commands
sudo sed -i 's/--mic-command .*/--mic-command '\''parecord --property=media.role=phone --rate=16000 --channels=1 --format=s16le --raw --latency-msec 10'\'' \\/g' "$WYOMING_SERVICE"
sudo sed -i 's/--snd-command .*/--snd-command '\''paplay --property=media.role=announce --rate=44100 --channels=1 --format=s16le --raw --latency-msec 10'\'' \\/g' "$WYOMING_SERVICE"

# Add new options
sudo sed -i '/--snd-command/a\    --snd-command-rate 44100 \\' "$WYOMING_SERVICE"
sudo sed -i '/--snd-command-rate/a\    --detection-command '\''/opt/wyoming-enhancements/snapcast/scripts/awake.sh'\'' \\' "$WYOMING_SERVICE"
sudo sed -i '/--detection-command/a\    --tts-stop-command '\''/opt/wyoming-enhancements/snapcast/scripts/done.sh'\'' \\' "$WYOMING_SERVICE"
sudo sed -i '/--tts-stop-command/a\    --error-command '\''/opt/wyoming-enhancements/snapcast/scripts/done.sh'\'' \\' "$WYOMING_SERVICE"

# Add PulseAudio requirement
sudo sed -i '/Requires=/a\Requires=pulseaudio.service' "$WYOMING_SERVICE"

# Modify Snapcast service
sudo sed -i '/After=/s/$/ pulseaudio.service/' /etc/systemd/system/snapclient.service

# Start and enable services
sudo systemctl enable --now pulseaudio.service snapclient.service
sudo systemctl daemon-reload
sudo systemctl restart wyoming-satellite.service

echo "${GREEN}Enhancements enabled successfully.${RESET}"
echo "${YELLOW}Please check the status of services with:${RESET}"
echo "sudo systemctl status wyoming-satellite.service pulseaudio.service snapclient.service"