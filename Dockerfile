FROM alpine:latest AS builder

RUN set -ex \
    && apk --no-cache add \
        git \
        autoconf \
        automake \
        libtool \
        pkgconf \
        gcc \
        g++ \
        make \
        cppunit-dev \
        gettext-dev \
        gnutls-dev \
        nettle-dev \
        gmp-dev \
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

COPY root/ /
COPY --from=builder /tmp/aria2/src/aria2c /usr/bin/aria2c

RUN set -xe \
    && apk add --no-cache \
        ca-certificates \
        c-ares \
        gmp \
        gnutls \
        libexpat \
        libgcc \
        libstdc++ \
        libssh2 \
        nettle \
        sqlite-libs \
        zlib \
    && chmod +x /entrypoint.sh

VOLUME /config /downloads

EXPOSE 6800

ENTRYPOINT ["/entrypoint.sh"]
