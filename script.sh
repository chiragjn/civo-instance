#!/bin/bash

set -ex

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

cd /tmp

# Install essentials
sudo apt-get update
sudo apt-get install -y \
  gcc \
  ca-certificates \
  curl \
  gnupg \
  wget \
  git \
  build-essential \
  software-properties-common

# Install drivers with GSP disabled
echo "options nvidia NVreg_EnableGpuFirmware=0" | sudo tee --append /etc/modprobe.d/nvidia.conf
wget https://us.download.nvidia.com/tesla/535.183.01/nvidia-driver-local-repo-ubuntu2204-535.183.01_1.0-1_amd64.deb
sudo dpkg -i nvidia-driver-local-repo-ubuntu2204-535.183.01_1.0-1_amd64.deb
sudo cp /var/nvidia-driver-local-repo-ubuntu2204-535.183.01/nvidia-driver-local-76AD990C-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get install -y --no-install-recommends cuda-drivers-535

# Install CUDA
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/12.1.1/local_installers/cuda-repo-ubuntu2204-12-1-local_12.1.1-530.30.02-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-12-1-local_12.1.1-530.30.02-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-12-1-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit

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

# Add nvtop
sudo add-apt-repository ppa:flexiondotorg/nvtop -y

# Add deadsnakes
sudo add-apt-repository ppa:deadsnakes/ppa -y

# Fetch packages index
sudo apt-get update

# Install all packages
sudo apt-get install -y --no-install-recommends \
  htop \
  nvtop \
  libcudnn8=8.9.7.29-1+cuda12.2 \
  libcudnn8-dev=8.9.7.29-1+cuda12.2 \
  libnccl2 \
  libnccl-dev \
  nvidia-container-toolkit \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  python3.11 \
  python3.11-dev \
  python3.11-venv

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
sudo systemctl restart docker

# Disable automatic updates
sudo apt-get remove -y unattended-upgrades

# Use Docker without root
sudo groupadd -f docker
sudo usermod -aG docker civo

# mount the volume
sudo mkdir -p /data/
sudo chown -R civo:civo /data/
sudo mount -o rw /dev/sda1 /data/
sudo mkdir -p /data/.cache/
sudo chown -R civo:civo /data/.cache

# Set history and caching on external volume
echo 'export HISTFILE=/data/.civo_bash_history' >> /home/civo/.bashrc
echo 'export PATH="/usr/local/cuda/bin:${PATH}"' >> /home/civo/.bashrc
echo 'export LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"' >> /home/civo/.bashrc
echo 'export HF_HOME=/data/.cache/huggingface' >> /home/civo/.bashrc
echo 'export PIP_CACHE_DIR=/data/.cache/pip' >> /home/civo/.bashrc

# Add the volume to /etc/fstab
echo '/dev/sda1 /data ext4 defaults 0 0' | sudo tee -a /etc/fstab

sudo reboot
