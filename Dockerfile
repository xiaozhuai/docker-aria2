FROM alpine:latest

COPY root/ /

RUN set -xe \
    && apk add --no-cache aria2 \
    && chmod +x /entrypoint.sh

VOLUME /config /downloads

EXPOSE 6800

ENTRYPOINT ["/entrypoint.sh"]
