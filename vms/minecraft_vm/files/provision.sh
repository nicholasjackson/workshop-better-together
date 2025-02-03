#! /bin/bash

set -e

# Install Java
apt-get update
apt-get install -y openjdk-21-jre-headless

# Install Rcon
curl -L -o rcon-cli.tar.gz https://github.com/itzg/rcon-cli/releases/download/1.6.10/rcon-cli_1.6.10_linux_amd64.tar.gz
tar -xzf rcon-cli.tar.gz
rm rcon-cli.tar.gz
mv rcon-cli /usr/local/bin

# Install Minecraft
mkdir /etc/minecraft
cd /etc/minecraft

## Add the EULA file the installer needs
echo "eula=true" > ./eula.txt

## Download the server jar and run the installer
curl -L -o fabric-installer.jar https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.1/fabric-installer-1.0.1.jar
java -Xmx2G -jar fabric-installer.jar server -mcversion 1.21.4 -downloadMinecraft

## Add the world
curl -L -o buccaneers_bay.tar.gz https://github.com/nicholasjackson/workshop-better-together/releases/download/v0.0.0/buccaneers_bay.tar.gz
tar -xzf buccaneers_bay.tar.gz
mv ./buccaneers_bay ./world

## Create the systemd service
cat <<EOF > /etc/systemd/system/minecraft.service
[Unit]
Description=Minecraft Server
After=network.target

[Service]
WorkingDirectory=/etc/minecraft
ExecStart=/usr/bin/java -Xmx2G -Xms2G -jar fabric-server-launch.jar nogui

[Install]
WantedBy=multi-user.target
EOF

systemctl enable minecraft