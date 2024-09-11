#!/usr/bin/env bash

# Define colors for status messages
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

echo "${YELLOW}Disabling PulseAudio and Snapclient enhancements...${RESET}"

# Modify Wyoming Satellite service
WYOMING_SERVICE="/etc/systemd/system/wyoming-satellite.service"

# Restore original mic and sound commands
sudo sed -i 's/--mic-command .*/--mic-command '\''arecord -D plughw:CARD=seeed2micvoicec,DEV=0 -r 16000 -c 1 -f S16_LE -t raw'\'' \\/g' "$WYOMING_SERVICE"
sudo sed -i 's/--snd-command .*/--snd-command '\''aplay -D plughw:CARD=seeed2micvoicec,DEV=0 -r 22050 -c 1 -f S16_LE -t raw'\'' \\/g' "$WYOMING_SERVICE"

# Remove added options
sudo sed -i '/--snd-command-rate/d' "$WYOMING_SERVICE"
sudo sed -i '/--detection-command/d' "$WYOMING_SERVICE"
sudo sed -i '/--tts-stop-command/d' "$WYOMING_SERVICE"
sudo sed -i '/--error-command/d' "$WYOMING_SERVICE"

# Remove PulseAudio requirement
sudo sed -i '/Requires=pulseaudio.service/d' "$WYOMING_SERVICE"

# Modify Snapcast service
sudo sed -i 's/ pulseaudio.service//' /etc/systemd/system/snapclient.service

# Stop and disable services
sudo systemctl stop pulseaudio.service snapclient.service
sudo systemctl disable pulseaudio.service snapclient.service
sudo systemctl daemon-reload
sudo systemctl restart wyoming-satellite.service

echo "${GREEN}Enhancements disabled successfully.${RESET}"
echo "${YELLOW}Please check the status of services with:${RESET}"
echo "sudo systemctl status wyoming-satellite.service"