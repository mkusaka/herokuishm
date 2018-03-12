### stage0
FROM heroku/heroku:16-build as build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update \
 && apt-get -qq -y --force-yes dist-upgrade \
 && apt-get clean \
 && rm -rf /var/cache/apt/archives/*

RUN JEMALLOC_URL="https://github.com/jemalloc/jemalloc/releases/download/4.5.0/jemalloc-4.5.0.tar.bz2" \
 && curl --silent -L $JEMALLOC_URL | tar -xjC /tmp \
 && cd /tmp/jemalloc-4.5.0 \
 && ./configure --disable-stats \
 && make -j \
 && mv lib/libjemalloc.so.2 /tmp/libjemalloc.so.2 \
 && cd / \
 && rm -rf /tmp/jemalloc-4.5.0

### stage1
FROM heroku/heroku:16

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update \
 && apt-get -qq -y --force-yes dist-upgrade \
 && apt-get -qq -y install \
     daemontools \
     pigz \
 && apt-get clean \
 && rm -rf /var/cache/apt/archives/*

RUN addgroup --quiet --gid "32767" "herokuishuser" \
 && adduser \
    --shell /bin/bash \
    --disabled-password \
    --force-badname \
    --no-create-home \
    --uid "32767" \
    --gid "32767" \
    --gecos "" \
    --quiet \
    --home "/app" \
    "herokuishuser" \
 && id herokuishuser

ENV STACK=heroku-16

RUN HEROKUISH_URL="https://github.com/gliderlabs/herokuish/releases/download/v0.4.0/herokuish_0.4.0_linux_x86_64.tgz" \
 && curl --silent -L $HEROKUISH_URL | tar -xzC /bin \
 && ln -s /bin/herokuish /build \
 && ln -s /bin/herokuish /start \
 && ln -s /bin/herokuish /exec

COPY --from=build /tmp/libjemalloc.so.2 /usr/lib/libjemalloc.so.2
