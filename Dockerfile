FROM gliderlabs/herokuish:latest
MAINTAINER fistfvck@gmail.com

COPY bin/compile /tmp/buildpacks/00_buildpack-multi/bin/
RUN cd /tmp \
 && curl -L https://github.com/jemalloc/jemalloc/releases/download/4.5.0/jemalloc-4.5.0.tar.bz2 | tar jxf - \
 && cd /tmp/jemalloc-4.5.0 \
 && ./configure --disable-stats \
 && make -j \
 && mv lib/libjemalloc.so.2 /usr/lib/libjemalloc.so.2 \
 && cd \
 && rm -rf /tmp/jemalloc-4.5.0 \
 && ls -l /usr/lib/libjemalloc.so.2
