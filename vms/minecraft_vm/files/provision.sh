#! /bin/bash

set -e

# Install Java
apt-get update
apt-get install -y openjdk-17-jre-headless

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
java -Xmx2G -jar fabric-installer.jar server -mcversion 1.20.1 -downloadMinecraft

## Add the world
curl -L -o task_1.tar.gz https://storage.googleapis.com/jumppad_sko/world_task_1.tar.gz
tar -xzf task_1.tar.gz
mv ./task_1 ./world

## Add the mods
curl -L -o mods.tar.gz https://storage.googleapis.com/jumppad_sko/minecraft_mods.tar.gz
tar -xzf mods.tar.gz

## Create the systemd service
cat <<EOF > /etc/systemd/system/minecraft.service
[Unit]
Description=Minecraft Server
After=network.target

[Service]
WorkingDirectory=/etc/minecraft
ExecStart=/usr/bin/java -Xmx2G -Xms2G -jar fabric-server-launch.jar nogui
EnvironmentFile=/etc/minecraft/env/minecraft.env

[Install]
WantedBy=multi-user.target
EOF

systemctl enable minecraft