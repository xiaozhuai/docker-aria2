FROM alpine:latest AS builder

RUN set -ex \
    && apk --no-cache add \
        git \
        autoconf \
        automake \
        libtool \
        pkgconf \
        build-base \
        cppunit-dev \
        gettext-dev \
        openssl-dev \
        libssh2-dev \
        c-ares-dev \
        expat-dev \
        zlib-dev \
        sqlite-dev \
    && cd /tmp \
    && git clone --depth=1 "https://github.com/aria2/aria2" \
    && cd aria2 \
    && autoreconf -i \
    && ./configure \
        --prefix=/usr \
        --sysconfdir=/etc \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info \
        --localstatedir=/var \
        --disable-nls \
        --with-ca-bundle=/etc/ssl/certs/ca-certificates.crt \
    && make -j $(nproc)

FROM alpine:latest

RUN set -xe \
    && apk add --no-cache \
        ca-certificates \
        c-ares \
        libexpat \
        libgcc \
        libstdc++ \
        libssh2 \
        libssl3 \
        sqlite-libs \
        zlib

COPY root/ /
COPY --from=builder /tmp/aria2/src/aria2c /usr/bin/aria2c

VOLUME /config /downloads

EXPOSE 6800

ENTRYPOINT ["/entrypoint.sh"]
