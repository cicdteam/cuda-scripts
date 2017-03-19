#!/bin/bash

NVIDIA_DRV_VER='367.57'
NVIDIA_DOCKER_VER='1.0.1'
CUDA_VER='8.0-cudnn5-runtime-ubuntu16.04'

echo; echo 'INSTALL LINUX IMAGE EXTRA'
sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe" >/dev/null 2>&1
sudo apt-get -yq update >/dev/null 2>&1
sudo apt-get -yq install linux-image-extra-$(uname -r) >/dev/null 2>&1
sudo apt-get -yq update >/dev/null 2>&1

echo; echo 'INSTALL DOCKER'
curl -sSL https://get.docker.com | sh >/dev/null 2>&1
sudo usermod -aG docker ubuntu

if [ "$(lspci | grep NVIDIA)" ]; then
    echo; echo 'DISABLE NOUVEAU DRIVER'
    cat <<'EOF' | sudo tee /etc/modprobe.d/blacklist-nouveau.conf >/dev/null
blacklist nouveau
blacklist lbm-nouveau
options nouveau modeset=0
alias nouveau off
alias lbm-nouveau off
EOF
    echo 'options nouveau modeset=0' | sudo tee -a /etc/modprobe.d/nouveau-kms.conf >/dev/null
    sudo update-initramfs -u >/dev/null 2>&1

    echo; echo "INSTALL NVIDIA DRIVER ${NVIDIA_DRV_VER}"
    sudo apt-get -yq install build-essential >/dev/null 2>&1
    wget -q -P /tmp http://us.download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_DRV_VER}/NVIDIA-Linux-x86_64-${NVIDIA_DRV_VER}.run
    sudo sh /tmp/NVIDIA-Linux-x86_64-${NVIDIA_DRV_VER}.run -s >/dev/null 2>&1
    rm -f /tmp/NVIDIA-Linux-x86_64-${NVIDIA_DRV_VER}.run >/dev/null 2>&1

    echo; echo 'INSTALL NVIDIA-DOCKER'
    wget -q -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v${NVIDIA_DOCKER_VER}/nvidia-docker_${NVIDIA_DOCKER_VER}-1_amd64.deb
    sudo dpkg -i /tmp/nvidia-docker*.deb >/dev/null 2>&1
    rm /tmp/nvidia-docker*.deb >/dev/null 2>&1

    echo; echo 'CLEANUP'
    sudo apt-get -yq purge build-essential >/dev/null 2>&1
    sudo apt-get -yq autoremove >/dev/null 2>&1
fi

echo; echo 'CHECK DOCKERIZED CUDA APP'
sudo docker pull nvidia/cuda:${CUDA_VER} >/dev/null 2>&1
sudo nvidia-docker run --rm nvidia/cuda:${CUDA_VER} nvidia-smi

echo; echo 'DONE'; echo
