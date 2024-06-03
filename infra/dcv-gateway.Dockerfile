FROM amazonlinux:2

RUN yum -y update
RUN yum -y install which wget jq tar procps netcat

RUN mkdir -p /opt/idea

WORKDIR /opt/idea

COPY dcv-connection-gateway /opt/idea/dcv-connection-gateway

RUN cd dcv-connection-gateway && chmod +x install_app.sh && ./install_app.sh

RUN mv -f /opt/idea/dcv-connection-gateway/public/images /usr/share/dcv/www/images &&\
     mv -f /opt/idea/dcv-connection-gateway/public/index.html /usr/share/dcv/www/index.html

HEALTHCHECK --interval=5s --timeout=10s --start-period=5s --retries=30 CMD nc -z -v -w 2 localhost 8989 || exit 1

CMD ["/opt/idea/dcv-connection-gateway/run_dcv_connection_gateway.sh"]
USER dcvcgw

# todo may need to do equivalent of systemd:
       # Privileges
       # AmbientCapabilities=CAP_NET_BIND_SERVICE
       # CapabilityBoundingSet=CAP_NET_BIND_SERVICE
       # NoNewPrivileges=yes
       #
       # # Sandboxing
       # MemoryDenyWriteExecute=yes
       # PrivateDevices=yes
       # PrivateTmp=yes
       # ProtectControlGroups=yes
       # ProtectHome=read-only
       # ProtectKernelModules=yes
       # ProtectKernelTunables=yes
       # ProtectSystem=full
       # RestrictNamespaces=yes
       # RestrictRealtime=yes