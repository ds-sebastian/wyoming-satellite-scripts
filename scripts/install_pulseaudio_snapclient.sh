#!/usr/bin/env bash

# Define colors for status messages
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Prompt for Snapcast server IP and verify connectivity
while true; do
    read -p "Enter the IP address of your Snapcast server: " SNAPCAST_SERVER_IP
    if ping -c 1 $SNAPCAST_SERVER_IP &> /dev/null
    then
        echo "${GREEN}Successfully connected to Snapcast server at $SNAPCAST_SERVER_IP${RESET}"
        break
    else
        echo "${RED}Unable to reach the Snapcast server at $SNAPCAST_SERVER_IP. Please check the IP and try again.${RESET}"
    fi
done

echo "${YELLOW}Installing PulseAudio...${RESET}"
sudo apt-get update
sudo apt-get install -y pulseaudio pulseaudio-utils

# Configure PulseAudio for system-wide mode
sudo systemctl --global disable pulseaudio.service pulseaudio.socket
sudo sed -i 's/; autospawn = yes/autospawn = no/' /etc/pulse/client.conf

# Create PulseAudio service
sudo tee /etc/systemd/system/pulseaudio.service > /dev/null << EOL
[Unit]
Description=PulseAudio system server

[Service]
Type=notify
ExecStart=pulseaudio --daemonize=no --system --realtime --log-target=journal

[Install]
WantedBy=multi-user.target
EOL

# Add users to pulse-access group
sudo sed -i '/^pulse-access:/ s/$/root,pi,snapclient,'"$USER"'/' /etc/group

# Configure PulseAudio for volume ducking
echo "load-module module-role-ducking trigger_roles=announce,phone,notification,event ducking_roles=any_role volume=33%" | sudo tee -a /etc/pulse/system.pa

echo "${YELLOW}Installing Snapcast client...${RESET}"
SNAPCAST_VERSION=$(curl -s https://api.github.com/repos/badaix/snapcast/releases/latest | grep 'tag_name' | sed -E 's/.*"v?([^"]+)".*/\1/')
ARCH=$(dpkg --print-architecture)

wget https://github.com/badaix/snapcast/releases/download/${SNAPCAST_VERSION}/snapclient_${SNAPCAST_VERSION}-1_${ARCH}_bookworm_with-pulse.deb
sudo dpkg -i snapclient_${SNAPCAST_VERSION}-1_${ARCH}.deb
sudo apt-get install -f

# Configure Snapcast client
sudo tee /etc/default/snapclient > /dev/null << EOL
START_SNAPCLIENT=true
SNAPCLIENT_OPTS="-h $SNAPCAST_SERVER_IP --player pulse:property=media.role=music --sampleformat 44100:16:*"
EOL

echo "${GREEN}PulseAudio and Snapclient installed successfully.${RESET}"
echo "${YELLOW}Please reboot your system to apply all changes.${RESET}"
