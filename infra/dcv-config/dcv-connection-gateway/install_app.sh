#!/bin/bash

#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance
#  with the License. A copy of the License is located at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  or in the 'license' file accompanying this file. This file is distributed on an 'AS IS' BASIS, WITHOUT WARRANTIES
#  OR CONDITIONS OF ANY KIND, express or implied. See the License for the specific language governing permissions
#  and limitations under the License.

set -x

APP_NAME="dcv-connection-gateway"


DCV_GPG_KEY="https://d1uj6qtbmh3dt5.cloudfront.net/NICE-GPG-KEY"
DCV_CONNECTION_GATEWAY_VERSION="2023.0.531-1.el7.x86_64"
DCV_CONNECTION_GATEWAY_URL="https://d1uj6qtbmh3dt5.cloudfront.net/nice-dcv-connection-gateway-el7.x86_64.rpm"
DCV_CONNECTION_GATEWAY_SHA256_URL="https://d1uj6qtbmh3dt5.cloudfront.net/nice-dcv-connection-gateway-el7.x86_64.rpm.sha256sum"

INTERNAL_ALB_ENDPOINT="https://dcv-broker" # "{{ context.config.get_cluster_internal_endpoint() }}" # todo
GATEWAY_TO_BROKER_PORT="8446" # {{ context.config.get_string("virtual-desktop-controller.dcv_broker.gateway_communication_port", required=True) }}

DCV_SERVER_X86_64_URL="https://d1uj6qtbmh3dt5.cloudfront.net/2023.0/Servers/nice-dcv-2023.0-14852-el7-x86_64.tgz" # "{{ context.config.get_string('global-settings.package_config.dcv.host.x86_64.linux.al2_rhel_centos7.url', required=True) }}"
DCV_SERVER_X86_64_TGZ="nice-dcv-2023.0-14852-el7-x86_64.tgz" # "{{ context.config.get_string('global-settings.package_config.dcv.host.x86_64.linux.al2_rhel_centos7.tgz', required=True) }}"
DCV_SERVER_X86_64_VERSION="2023.0-14852-el7-x86_64" # "{{ context.config.get_string('global-settings.package_config.dcv.host.x86_64.linux.al2_rhel_centos7.version', required=True) }}"
DCV_SERVER_X86_64_SHA256_HASH="ab662e5bb79f06c46182f83b582538f2dffe5faa1d3da0251404fb96e8310ffe" # "{{ context.config.get_string('global-settings.package_config.dcv.host.x86_64.linux.al2_rhel_centos7.sha256sum', required=True) }}"

DCV_SERVER_AARCH64_URL="https://d1uj6qtbmh3dt5.cloudfront.net/2023.0/Servers/nice-dcv-2023.0-14852-el7-aarch64.tgz" # "{{ context.config.get_string('global-settings.package_config.dcv.host.aarch64.linux.al2_rhel_centos7.url', required=True) }}"
DCV_SERVER_AARCH64_TGZ="nice-dcv-2023.0-14852-el7-aarch64.tgz" # "{{ context.config.get_string('global-settings.package_config.dcv.host.aarch64.linux.al2_rhel_centos7.tgz', required=True) }}"
DCV_SERVER_AARCH64_VERSION="2023.0-14852-el7-aarch64" # "{{ context.config.get_string('global-settings.package_config.dcv.host.aarch64.linux.al2_rhel_centos7.version', required=True) }}"
DCV_SERVER_AARCH64_SHA256_HASH="1c7965898ad963b90047bf05bd23f2b6fd9d6e074d11354687a8a908f11257c3" # "{{ context.config.get_string('global-settings.package_config.dcv.host.aarch64.linux.al2_rhel_centos7.sha256sum', required=True) }}"


DCV_WEB_VIEWER_INSTALL_LOCATION="/usr/share/dcv/www"

timestamp=$(date +%s)

function install_dcv_connection_gateway() {
  rpm -q nice-dcv-connection-gateway
  if [[ "$?" != "0"  ]]; then
    yum install -y nc
    rpm --import ${DCV_GPG_KEY}
    wget ${DCV_CONNECTION_GATEWAY_URL}
    fileName=$(basename ${DCV_CONNECTION_GATEWAY_URL})
    urlSha256Sum=$(wget -O - ${DCV_CONNECTION_GATEWAY_SHA256_URL})
    if [[ $(sha256sum ${fileName} | awk '{print $1}') != ${urlSha256Sum} ]];  then
      echo -e "FATAL ERROR: Checksum for DCV Connection Gateway failed. File may be compromised." > /etc/motd
      exit 1
    fi
    yum install -y ${fileName}
    rm -f ${fileName}
  fi
}

function install_dcv_web_viewer() {
  echo "# installing dcv web viewer ..."

  local machine=$(uname -m) #x86_64 or aarch64
  local DCV_SERVER_URL=""
  local DCV_SERVER_TGZ=""
  local DCV_SERVER_VERSION=""
  local DCV_SERVER_SHA256_HASH=""
  if [[ $machine == "x86_64" ]]; then
    # x86_64
    DCV_SERVER_URL=${DCV_SERVER_X86_64_URL}
    DCV_SERVER_TGZ=${DCV_SERVER_X86_64_TGZ}
    DCV_SERVER_VERSION=${DCV_SERVER_X86_64_VERSION}
    DCV_SERVER_SHA256_HASH=${DCV_SERVER_X86_64_SHA256_HASH}
  else
    # aarch64
    DCV_SERVER_URL=${DCV_SERVER_AARCH64_URL}
    DCV_SERVER_TGZ=${DCV_SERVER_AARCH64_TGZ}
    DCV_SERVER_VERSION=${DCV_SERVER_AARCH64_VERSION}
    DCV_SERVER_SHA256_HASH=${DCV_SERVER_AARCH64_SHA256_HASH}
  fi

  rpm -q nice-dcv-web-viewer
  if [[ "$?" != "0"  ]]; then
    wget ${DCV_SERVER_URL}

    if [[ $(sha256sum ${DCV_SERVER_TGZ} | awk '{print $1}') != ${DCV_SERVER_SHA256_HASH} ]];  then
        echo -e "FATAL ERROR: Checksum for DCV Server failed. File may be compromised." > /etc/motd
        exit 1
    fi
    tar zxvf ${DCV_SERVER_TGZ}

    pushd nice-dcv-${DCV_SERVER_VERSION}
    rpm -ivh nice-dcv-web-viewer-*.${machine}.rpm
#    {% elif context.base_os in ('rhel7', 'rhel8', 'rhel9', 'centos7') -%}
#      rpm -ivh nice-dcv-web-viewer-*.${machine}.rpm --nodeps
#    {% endif -%}
    popd
    rm -rf nice-dcv-${DCV_SERVER_VERSION}
    rm -rf ${DCV_SERVER_TGZ}
  fi

}

function configure_dcv_connection_gateway() {
  if [[ -f /etc/dcv-connection-gateway/dcv-connection-gateway.conf ]]; then
    mv /etc/dcv-connection-gateway/dcv-connection-gateway.conf /etc/dcv-connection-gateway/dcv-connection-gateway.conf.${timestamp}
  fi
  touch /etc/dcv-connection-gateway/dcv-connection-gateway.conf
  echo -e "[log]
level = \"trace\"

[gateway]
quic-listen-endpoints = [\"0.0.0.0:8443\", \"[::]:8443\"]
web-listen-endpoints = [\"0.0.0.0:8443\", \"[::]:8443\"]
#cert-file = \"/etc/dcv-connection-gateway/certs/default_cert.pem\"
#cert-key-file = \"/etc/dcv-connection-gateway/certs/default_key_pkcs8.pem\"

[health-check]
bind-addr = \"::\"
port = 8989

[dcv]
tls-strict = false

[resolver]
url = \"${INTERNAL_ALB_ENDPOINT}:${GATEWAY_TO_BROKER_PORT}\"
tls-strict = false

[web-resources]
local-resources-path = \"/usr/share/dcv/www\"
tls-strict = false
" > /etc/dcv-connection-gateway/dcv-connection-gateway.conf

#  systemctl enable dcv-connection-gateway
#  systemctl start dcv-connection-gateway
}

install_dcv_connection_gateway
install_dcv_web_viewer

function configure_certificates() {
  local CERT_CONTENT=$(get_secret ${CERTIFICATE_SECRET_ARN})
  local PRIVATE_KEY_CONTENT=$(get_secret ${PRIVATE_KEY_SECRET_ARN})
  mkdir -p /etc/dcv-connection-gateway/certs/

  if [[ -f /etc/dcv-connection-gateway/certs/default_cert.pem ]]; then
    mv /etc/dcv-connection-gateway/certs/default_cert.pem /etc/dcv-connection-gateway/certs/default_cert.pem.${timestamp}
  fi
  if [[ -f /etc/dcv-connection-gateway/certs/default_key_pkcs1.pem ]]; then
    mv /etc/dcv-connection-gateway/certs/default_key_pkcs1.pem /etc/dcv-connection-gateway/certs/default_key_pkcs1.pem.${timestamp}
  fi
  if [[ -f /etc/dcv-connection-gateway/certs/default_key_pkcs8.pem ]]; then
    mv /etc/dcv-connection-gateway/certs/default_key_pkcs8.pem /etc/dcv-connection-gateway/certs/default_key_pkcs8.pem.${timestamp}
  fi
  touch /etc/dcv-connection-gateway/certs/default_cert.pem
  touch /etc/dcv-connection-gateway/certs/default_key_pkcs1.pem
  echo -e "${CERT_CONTENT}" > /etc/dcv-connection-gateway/certs/default_cert.pem
  echo -e "${PRIVATE_KEY_CONTENT}" > /etc/dcv-connection-gateway/certs/default_key_pkcs1.pem
  openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in /etc/dcv-connection-gateway/certs/default_key_pkcs1.pem -out /etc/dcv-connection-gateway/certs/default_key_pkcs8.pem
  chmod 600 /etc/dcv-connection-gateway/certs/default_cert.pem
  chmod 600 /etc/dcv-connection-gateway/certs/default_key_pkcs1.pem
  chmod 600 /etc/dcv-connection-gateway/certs/default_key_pkcs8.pem

  chown -R dcvcgw:dcvcgw /etc/dcv-connection-gateway/certs/default_cert.pem
  chown -R dcvcgw:dcvcgw /etc/dcv-connection-gateway/certs/default_key_pkcs1.pem
  chown -R dcvcgw:dcvcgw /etc/dcv-connection-gateway/certs/default_key_pkcs8.pem
}
#configure_certificates todo need to do this at runtime probably

configure_dcv_connection_gateway