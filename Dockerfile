FROM alpine:3.21.3

ARG S6_OVERLAY_VERSION=3.2.0.2
ARG POSTFIX_VERSION=3.9.0-r1
ARG GOMPLATE_VERSION=3.11.7-r6

RUN apk add --update --no-cache postfix=${POSTFIX_VERSION} postfix-pgsql=${POSTFIX_VERSION} gomplate=${GOMPLATE_VERSION} \
    && rm -rf /var/cache/apk/* \
    && mkdir -pv /etc/postfix/pgsql

# copy configs
COPY rootfs /

# Install s6-overlay
RUN export arch="$(apk --print-arch)" \
 && apk add --update --no-cache --virtual .tool-deps \
        curl \
 && curl -fL -o /tmp/s6-overlay-noarch.tar.xz \
         https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz \
 && curl -fL -o /tmp/s6-overlay-bin.tar.xz \
         https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${arch}.tar.xz \
 && tar -xf /tmp/s6-overlay-noarch.tar.xz -C / \
 && tar -xf /tmp/s6-overlay-bin.tar.xz -C / \
    \
 # Cleanup unnecessary stuff
 && apk del .tool-deps \
 && rm -rf /var/cache/apk/* /tmp/* \
 && chmod +x /etc/s6-overlay/s6-rc.d/*/up \
 && chmod +x /etc/s6-overlay/scripts/*

ENTRYPOINT ["/init"]

CMD ["/usr/sbin/postfix", "start-fg"]
