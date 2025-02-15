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
curl -L -o mods.tar.gz https://storage.googleapis.com/jumppad_sko/mods_v0.0.1.tar.gz
tar -xzf mods.tar.gz
mv ./server_mods ./mods

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

cat <<EOF > /etc/minecraft/server.properties
#Minecraft server properties
#Thu Feb 06 10:21:30 UTC 2025
accepts-transfers=false
allow-flight=false
allow-nether=true
broadcast-console-to-ops=true
broadcast-rcon-to-ops=true
bug-report-link=
difficulty=easy
enable-command-block=false
enable-jmx-monitoring=false
enable-query=false
enable-rcon=true
enable-status=true
enforce-secure-profile=true
enforce-whitelist=true
entity-broadcast-range-percentage=100
force-gamemode=true
function-permission-level=2
gamemode=survival
generate-structures=true
generator-settings={}
hardcore=false
hide-online-players=false
initial-disabled-packs=
initial-enabled-packs=vanilla
level-name=world
level-seed=
level-type=minecraft\:normal
log-ips=true
max-chained-neighbor-updates=1000000
max-players=100
max-tick-time=60000
max-world-size=29999984
motd=Welcome to SKO
network-compression-threshold=256
online-mode=false
op-permission-level=4
pause-when-empty-seconds=60
player-idle-timeout=0
prevent-proxy-connections=false
pvp=true
query.port=25565
rate-limit=0
rcon.password=password
rcon.port=25575
region-file-compression=deflate
require-resource-pack=false
resource-pack=
resource-pack-id=
resource-pack-prompt=
resource-pack-sha1=
server-ip=
server-port=25565
simulation-distance=10
spawn-monsters=true
spawn-protection=16
sync-chunk-writes=true
text-filtering-config=
text-filtering-version=0
use-native-transport=true
view-distance=10
white-list=false
EOF

systemctl enable minecraft