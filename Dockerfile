FROM heroku/cedar:14

RUN apt-get update && apt-get -qq -y --force-yes dist-upgrade && apt-get clean && rm -rf /var/cache/apt/archives/*
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

RUN JEMALLOC_URL="https://github.com/jemalloc/jemalloc/releases/download/4.5.0/jemalloc-4.5.0.tar.bz2" \
 && curl --silent -L $JEMALLOC_URL | tar -xjC /tmp \
 && cd /tmp/jemalloc-4.5.0 \
 && ./configure --disable-stats \
 && make -j \
 && mv lib/libjemalloc.so.2 /usr/lib/libjemalloc.so.2 \
 && cd / \
 && rm -rf /tmp/jemalloc-4.5.0 \
 && ls -l /usr/lib/libjemalloc.so.2

RUN HEROKUISH_URL="https://github.com/gliderlabs/herokuish/releases/download/v0.3.33/herokuish_0.3.33_linux_x86_64.tgz" \
 && curl --silent -L $HEROKUISH_URL | tar -xzC /bin \
 && ln -s /bin/herokuish /build \
 && ln -s /bin/herokuish /start \
 && ln -s /bin/herokuish /exec

ADD heroku-buildpack-multi /tmp/buildpacks/00_buildpack-multi

RUN /bin/herokuish buildpack install https://github.com/heroku/heroku-buildpack-ruby   v174 01_buildpack-ruby \
 && /bin/herokuish buildpack install https://github.com/heroku/heroku-buildpack-nodejs v118 02_buildpack-nodejs
