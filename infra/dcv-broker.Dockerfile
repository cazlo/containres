FROM amazonlinux:2

RUN yum -y update
RUN yum -y install which wget jq sudo procps openssl hostname
# todo might need to also install on here the cloudwatch agent stuff
RUN mkdir -p /opt/idea

WORKDIR /opt/idea

COPY dcv-broker /opt/idea/dcv-broker

RUN cd dcv-broker && chmod +x install_app.sh && ./install_app.sh

# smokecheck install
RUN dcv-session-manager-broker --help

COPY dcv-broker/dcv-broker-overrides.sh /usr/share/dcv-session-manager-broker/bin/dcv-session-manager-broker.sh
RUN chmod +x /usr/share/dcv-session-manager-broker/bin/dcv-session-manager-broker.sh

# todo might need to do some pre-run configuration based on env vars todo things like overwrite aws region
CMD /usr/share/dcv-session-manager-broker/bin/dcv-session-manager-broker.sh
USER dcvsmbroker