#!/bin/bash

set -e

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg wget build-essential

# Add container toolkit repo
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Add Docker's official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# Install all the Docker dependencies
sudo apt-get install -y nvidia-container-toolkit docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Stop Docker
sudo systemctl stop docker

# Modify the Docker daemon config to use the cgroupfs cgroup driver
sudo mkdir -p /etc/docker

# Do any modifications to the Docker daemon config here
sudo tee /etc/docker/daemon.json > /dev/null <<-EOF
{
  "default-runtime": "nvidia",
  "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
  },
  "exec-opts": ["native.cgroupdriver=cgroupfs"],
  "log-driver": "json-file"
}
EOF
# sudo nvidia-ctk runtime configure --runtime=docker

# Start Docker again
sudo systemctl start docker

# Install Python 3.11 and its dependencies
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update
sudo apt-get install -y python3.11 python3.11-dev python3.11-venv

# Disable automatic updates
sudo apt-get remove -y unattended-upgrades

# mount the volume
sudo mkdir -p /data/
sudo chown -R civo:civo /data/
sudo mount -o rw /dev/sda1 /data/

# Rootless Docker
sudo groupadd docker
sudo usermod -aG docker civo
newgrp docker