FROM amazonlinux:2


RUN mkdir -p /opt/idea

WORKDIR /opt/idea

COPY dcv-connection-gateway /opt/idea/dcv-connection-gateway

# todo some equivalent of RUN cd dcv-connection-gateway && install_app.sh