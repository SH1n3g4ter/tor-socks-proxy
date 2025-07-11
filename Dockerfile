FROM alpine:3.17

LABEL maintainer="Peter Dave Hello <hsu@peterdavehello.org>"
LABEL name="tor-socks-proxy"
LABEL version="latest"

RUN echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/testing'   >> /etc/apk/repositories && \
    apk -U upgrade && \
    apk -v add libcap tor@edge obfs4proxy@edge curl && \
    chmod 700 /var/lib/tor && \
    rm -rf /var/cache/apk/* && \
    tor --version
COPY --chown=tor:root torrc /etc/tor/
RUN mkdir /app
COPY --chown=tor:root entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

HEALTHCHECK --timeout=10s --start-period=60s \
    CMD curl --fail --socks5-hostname localhost:9150 -I -L 'https://www.facebookwkhpilnemxj7asaniu7vnjjbiltxjqhye3mhbshg7kx5tfyd.onion/' || exit 1

RUN setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/tor
USER tor
EXPOSE 53/udp 9150/tcp 9151/tcp 9152/tcp

CMD ["sh","/app/entrypoint.sh"]
