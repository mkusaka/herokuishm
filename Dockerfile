FROM heroku/heroku:16

ENV DEBIAN_FRONTEND="noninteractive" \
    STACK="heroku-16"

RUN apt-get -qq update \
 && apt-get -qq -y --force-yes dist-upgrade \
 && apt-get -qq -y --no-install-recommends install \
      daemontools=1:0.76-6ubuntu1 \
      libjemalloc1=3.6.0-9ubuntu1 \
      pigz=2.3.1-2 \
 && apt-get clean \
 && rm -rf /var/cache/apt/archives/* \
 && addgroup --quiet --gid "32767" "herokuishuser" \
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
 && HEROKUISH_URL="https://github.com/gliderlabs/herokuish/releases/download/v0.4.2/herokuish_0.4.2_linux_x86_64.tgz" \
 && curl --silent --location $HEROKUISH_URL | tar -xzC /bin \
 && ln -s /bin/herokuish /build \
 && ln -s /bin/herokuish /start \
 && ln -s /bin/herokuish /exec

ONBUILD ENV LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.1"
