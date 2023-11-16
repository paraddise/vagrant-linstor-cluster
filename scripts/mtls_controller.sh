#!/usr/bin/env bash

source "$(dirname $0)/mtls_base.sh"
H=$(hostname)

create_cert $H

export SERVER_CERTS_PATH=/vagrant/certs/$H/keystore.jks
export TRUSTED_CERTS_PATH=/vagrant/certs/certs-for-satellite.jks

import_keystore $SERVER_CERTS_PATH $TRUSTED_CERTS_PATH
#envsubst < /vagrant/scripts/linstor_controller.toml.template | sudo tee /etc/linstor/linstor.toml

ln -sf $SERVER_CERTS_PATH /etc/linstor/ssl/keystore.jks
ln -sf /vagrant/certs/certs-for-controller.jks /etc/linstor/ssl/certificates.jks
