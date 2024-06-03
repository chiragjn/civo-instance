#!/bin/bash

# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# install all the docker dependencies
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# stop docker
sudo systemctl stop docker

# modify the docker daemon config to use the cgroupfs cgroup driver
sudo mkdir -p /etc/docker

# do any modifications to the docker daemon config here
sudo tee /etc/docker/daemon.json <<EOF
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

# start docker again
sudo systemctl start docker

# disable automatic updates
sudo apt remove unattended-upgrades


