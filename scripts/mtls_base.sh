#!/usr/bin/env bash
set -euxo pipefail

export STOREPASS=${STOREPASS:-linstor}
export KEYPASS=${KEYPASS:-linstor}
export local_ip="$(ip --json a s | jq -r '.[] | if .ifname == "eth1" then .addr_info[] | if .family == "inet" then .local else empty end else empty end')"

create_cert() {
  SERVICE="$1"
  mkdir -p /vagrant/certs/$SERVICE/
  keytool -keyalg ec -groupname secp256r1 -genkey \
  -storepass "$STOREPASS" -keypass "$KEYPASS" \
  -alias "$SERVICE" -keystore "/vagrant/certs/$SERVICE/keystore.jks" \
  -dname "CN=Bulat Linstor Cluster, OU=$local_ip, O=Example, L=Vienna, ST=Austria, C=AT"
}

import_keystore() {
  FROM="$1"
  TO="$2"
  keytool -importkeystore\
   -srcstorepass "$STOREPASS" -deststorepass "$STOREPASS" -keypass "$KEYPASS"\
   -srckeystore $FROM -destkeystore $TO
}

mkdir -p /vagrant/certs /etc/linstor/ssl
