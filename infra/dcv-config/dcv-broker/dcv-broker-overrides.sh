#!/bin/bash

BROKER_BIN_DIR="/usr/share/dcv-session-manager-broker/bin"

source "${BROKER_BIN_DIR}/common.sh"
source "${BROKER_BIN_DIR}/manage-certificates.sh"

check_user "${SERVICE_USER}" "DCV Session Manager Broker can only be run by ${SERVICE_USER}"

_java=$(get_java_cmd)
[ "${_java}" = "java" ] && echo -e "Using system default Java runtime\n" || echo -e "Using Java runtime ${_java}\n"

check_java_version "${_java}" "${REQUIRED_JAVA_VERSION_MAJOR}"

manage_certificates

"${_java}" ${JVM_OPTS} ${LOG_FILE_SUFFIX} -jar \
    ${BROKER_COMMAND_ENV} \
    ${BROKER_COMMAND_JAR} \
    run-broker \
    ${BROKER_CONF_FILE_PROPERTY}
#    > /dev/null NOTE: this is the only override, for stdout logging of the app
