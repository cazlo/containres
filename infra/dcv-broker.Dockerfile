FROM amazonlinux:2

RUN mkdir -p /opt/idea

WORKDIR /opt/idea

COPY dcv-broker /opt/idea/dcv-broker

# todo some equivalent of RUN cd dcv-broker && install_app.sh