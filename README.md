# Dockerized Nvidia CUDA on Ubuntu

This repo contain simple Bash script used to install Nvidia support on Ubuntu OS to run CUDA related docker containers.

### How to install Nvidia drivers

Login to your GPU-based box running Ubuntu and execute:

```
curl -sL http://bit.do/ubuntu-cuda | sh
```

### What script doing

Script perfroms next actions:

- Install linux image extra package
- Install latest docker engine
- Disable Nouveau driver
- Install Nvidia driver **v367.57**
- Install nvidia-docker plugin
- Pull `nvidia/cuda:8.0-cudnn5-runtime-ubuntu16.04` docker image and run `nvidia-smi` in container

### Script output

```
~$ curl -sL http://bit.do/ubuntu-cuda | sh

INSTALL LINUX IMAGE EXTRA

INSTALL DOCKER

DISABLE NOUVEAU DRIVER

INSTALL NVIDIA DRIVER 367.57

INSTALL NVIDIA-DOCKER

CLEANUP

CHECK DOCKERIZED CUDA APP
Sun Mar 19 07:29:17 2017
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 367.57                 Driver Version: 367.57                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GRID K520           Off  | 0000:00:03.0     Off |                  N/A |
| N/A   35C    P8    17W / 125W |      0MiB /  4036MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID  Type  Process name                               Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+

DONE

```

### How it tested

Script tested over AWS `g2.2xlarge` instances running **Ubuntu 14.04** and **Ubuntu 16.04**.

Also dockerized [TensorFlow](https://github.com/tensorflow/tensorflow/tree/master/tensorflow/tools/docker#running-the-container) tested after Nvidia drivers installed
by running `nvidia-docker run -it -p 8888:8888 gcr.io/tensorflow/tensorflow:latest-gpu` (Jupiter Notebook with TensorFlow).

