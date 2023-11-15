#!/usr/bin/env bash
set -euxo pipefail

sudo apt-get update
sudo apt-get install -y linux-headers-$(uname -r)
sudo add-apt-repository -y ppa:linbit/linbit-drbd9-stack
sudo apt-get install -y drbd-dkms drbd-utils linstor-controller linstor-satellite linstor-client python-linstor jq
sudo modprobe drbd
lsmod | grep -i drbd
echo drbd | sudo tee /etc/modules-load.d/drbd.conf
