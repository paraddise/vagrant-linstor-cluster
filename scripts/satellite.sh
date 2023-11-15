#!/usr/bin/env bash

set -euxo pipefail

local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"

if [[ -z "$CONTROLLERS" ]]; then echo "No controllers specified to connect"; fi
cat /vagrant/scripts/linstor-client.conf.template | envsubst | sudo tee /etc/linstor/linstor-client.conf

sudo systemctl enable --now linstor-satellite.service

linstor node create "$(hostname)" "$local_ip" --node-type Satellite
