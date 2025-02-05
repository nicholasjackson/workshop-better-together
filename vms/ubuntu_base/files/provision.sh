#! /bin/bash

set -e

# Stop and disable apt-daily.timer
sudo systemctl stop apt-daily.timer
sudo systemctl disable apt-daily.timer

# Stop and disable apt-daily-upgrade.timer
sudo systemctl stop apt-daily-upgrade.timer
sudo systemctl disable apt-daily-upgrade.timer