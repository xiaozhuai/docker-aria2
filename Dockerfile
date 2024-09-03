FROM alpine:latest AS builder

RUN set -ex \
    && apk --no-cache add \
        git \
        autoconf \
        automake \
        libtool \
        pkgconf \
        build-base \
        gettext-dev \
        c-ares-dev \
        expat-dev \
        libssh2-dev \
        sqlite-dev \
        openssl-dev \
        jemalloc-dev \
        zlib-dev \
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
        --with-jemalloc \
    && make -j $(nproc) \
    && strip src/aria2c

FROM alpine:latest

RUN set -ex \
    && apk add --no-cache \
        ca-certificates \
        libgcc \
        libstdc++ \
        c-ares \
        libexpat \
        libssh2 \
        sqlite-libs \
        libssl3 \
        libcrypto3 \
        jemalloc \
        zlib

COPY root/ /
COPY --from=builder /tmp/aria2/src/aria2c /usr/bin/aria2c

VOLUME /config /downloads

EXPOSE 6800

ENTRYPOINT ["/entrypoint.sh"]
