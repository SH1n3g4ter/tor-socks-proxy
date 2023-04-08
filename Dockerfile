FROM alpine:3.17

LABEL maintainer="Peter Dave Hello <hsu@peterdavehello.org>"
LABEL name="tor-socks-proxy"
LABEL version="latest"

RUN echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/testing'   >> /etc/apk/repositories && \
    apk -U upgrade && \
    apk -v add tor@edge obfs4proxy@edge curl nc && \
    chmod 700 /var/lib/tor && \
    rm -rf /var/cache/apk/* && \
    tor --version
COPY --chown=tor:root torrc_base /etc/tor/
RUN mkdir /app
COPY --chown=tor:root entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
COPY --chown=tor:root newip.sh /app/newip.sh
RUN chmod +x /app/newip.sh && ln -s /app/newip.sh /bin/newip
RUN chmod 777 /etc/tor
RUN mkdir -p /var/lib/tor && chmod 777 /var/lib/tor

#HEALTHCHECK --timeout=10s --start-period=60s \
#    CMD curl --fail --socks5-hostname localhost:9150 -I -L 'https://www.facebookwkhpilnemxj7asaniu7vnjjbiltxjqhye3mhbshg7kx5tfyd.onion/' || exit 1

USER tor
EXPOSE 8853/udp 9000-9127/tcp

CMD ["sh","/app/entrypoint.sh"]