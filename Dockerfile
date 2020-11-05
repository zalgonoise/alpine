FROM alpine:latest

RUN apk add \
    --no-cache \
    --update \
    zsh \
    curl \
    coreutils \
    tzdata \
    shadow \
    procps \
    ca-certificates

RUN mkdir /config /src \
    && ln -s -f /src /config/src \
    && ln -s -f /etc/services.d /config/exec \
    && ln -s -f /etc/cont-init.d /config/init \   
    && groupmod -g 1000 users \
    && useradd -u 1001 -U -d /config -s /bin/zsh app \
    && usermod -G users app


ADD https://github.com/just-containers/s6-overlay/releases/download/v2.1.0.2/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /

COPY ./rootfs /

ENTRYPOINT ["/init"]