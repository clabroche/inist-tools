#!/bin/bash
clear
# Ask user to say what sh he uses (zsh || bash)
read -p "What is your sh ? (zsh || bash)" env
echo $env
# Download latest debian release
wget https://raw.githubusercontent.com/Inist-CNRS/inist-tools/master/releases/inist-tools_latest.deb
# Installation
sudo dpkg -i ./inist-tools_latest.deb
# Clean
rm ./inist-tools_latest.deb

# Set environnement varible in each sh we want
if [ $env = 'zsh' ]; then
  echo ". /opt/inist-tools/inistrc" >> ~/.zshrc
  echo "alias inist-status=\"inist --status | grep ' on '\"" >> ~/.zshrc

  # Compatibility for zsh
  cd /opt/inist-tools
  sudo grep -rl ' == ' ./ | xargs sudo sed -i "s/ == / '==' /g"
  sudo grep -rl '$SUDO' ./ | xargs sudo sed -i "s/\$SUDO/sudo/g"

  # Return to home
  cd
fi
if [ $env = "bash" ]; then
  echo ". /opt/inist-tools/inistrc" >> ~/.bashrc
  echo "alias inist-status=\"inist --status | grep ' on '\"" >> ~/.bashrc
fi



# Desactivation of all service for inist in default
for service in shell ${INIST_SERVICES:="desktop apt docker github npm curl bower wget"}
do
  /opt/inist-tools/inistexec $service off
done;

# Reload environnement
if [ $env = 'zsh' ]; then
  zsh
fi
if [ $env = "bash" ]; then
  bash
fi
