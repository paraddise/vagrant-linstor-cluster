#!/usr/bin/env bash
set -euxo pipefail

local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"

# TODO(): firewall

sudo systemctl enable --now linstor-controller.service
linstor node create $(hostname) "$local_ip" --node-type Controller --communication-type SSL
