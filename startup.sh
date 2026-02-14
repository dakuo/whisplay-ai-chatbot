#!/bin/bash

# if graphical interface is enabled, ask user whether to disable graphical interface
if [ "$(systemctl get-default)" == "graphical.target" ]; then
    echo "Graphical interface is currently enabled."
    read -p "Disabling graphical interface is recommended for a headless setup. Do you want to disable the graphical interface? (y/n) " disable_gui
    if [[ "$disable_gui" == "y" ]]; then
        echo "Disabling graphical interface..."
        sudo systemctl set-default multi-user.target
        echo "Graphical interface disabled. You can re-enable it later with 'sudo systemctl set-default graphical.target'."
    else
        echo "Keeping graphical interface enabled."
    fi
else
    echo "Graphical interface is currently disabled."
fi

<<<<<<< HEAD
# Get user info
TARGET_USER=$(whoami)
USER_HOME=$HOME
TARGET_UID=$(id -u $TARGET_USER)

# Make sure we do not return roon (in case user called the script with sudo)
if [ "$TARGET_USER" == "root" ]; then
    echo "Error: Please run this script as your normal user (WITHOUT sudo)."
    echo "The script will ask for sudo permissions only when writing the service file."
    exit 1
fi

echo "----------------------------------------"
echo "Detected User: $TARGET_USER"
echo "Detected Home: $USER_HOME"
echo "Detected UID:  $TARGET_UID"

# Find Node bin
NODE_BIN=$(which node)

if [ -z "$NODE_BIN" ]; then
    echo "Error: Could not find 'node'. Make sure you can run 'node -v' in this terminal."
    exit 1
fi

NODE_FOLDER=$(dirname $NODE_BIN)
echo "Found Node at: $NODE_FOLDER"
echo "----------------------------------------"

# Create the service file
echo "Creating systemd service file..."
sudo tee /etc/systemd/system/chatbot.service > /dev/null <<EOF
=======
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_UID="$(id -u "$TARGET_USER")"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$TARGET_HOME" ]; then
  echo "Failed to resolve home directory for user: $TARGET_USER"
  exit 1
fi

echo "Setting up the chatbot service..."

sudo bash -c "cat > /etc/systemd/system/chatbot.service <<EOF
>>>>>>> f3957ae (edited the startup.sh script)
[Unit]
Description=Chatbot Service
After=network.target sound.target
Wants=sound.target

[Service]
Type=simple
User=$TARGET_USER
Group=audio
SupplementaryGroups=audio video gpio

<<<<<<< HEAD
# Use the dynamic Home Directory
WorkingDirectory=$USER_HOME/whisplay-ai-chatbot
ExecStart=/bin/bash $USER_HOME/whisplay-ai-chatbot/run_chatbot.sh

# Inject the dynamic Node path and dynamic User ID
Environment=PATH=$NODE_FOLDER:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
Environment=HOME=$USER_HOME
Environment=XDG_RUNTIME_DIR=/run/user/$TARGET_UID
Environment=NODE_ENV=production
=======
WorkingDirectory=$REPO_DIR
ExecStart=/bin/bash $REPO_DIR/run_chatbot.sh

# Environment variables (ALSA / mpg123 are very important)
Environment=PATH=/usr/local/bin:/usr/bin:/bin:$TARGET_HOME/.local/bin
Environment=HOME=$TARGET_HOME
Environment=XDG_RUNTIME_DIR=/run/user/$TARGET_UID
>>>>>>> f3957ae (edited the startup.sh script)

# Audio permissions
PrivateDevices=no

<<<<<<< HEAD
# Logs
StandardOutput=append:$USER_HOME/whisplay-ai-chatbot/chatbot.log
StandardError=append:$USER_HOME/whisplay-ai-chatbot/chatbot.log
=======
StandardOutput=append:$REPO_DIR/chatbot.log
StandardError=append:$REPO_DIR/chatbot.log
>>>>>>> f3957ae (edited the startup.sh script)

Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
<<<<<<< HEAD
EOF

# start the service
echo "Service file created. Reloading Systemd..."
=======
EOF"

echo "Chatbot service file created."
echo "Enabling and starting the chatbot service..."

>>>>>>> f3957ae (edited the startup.sh script)
sudo systemctl daemon-reload
sudo systemctl enable chatbot.service
sudo systemctl restart chatbot.service

echo "Done! Chatbot is starting..."
echo "Checking status..."
sleep 2
sudo systemctl status chatbot --no-pager