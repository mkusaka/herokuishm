# -*- mode: dockerfile -*-
ADD slug.tgz /app
ENV LD_PRELOAD="/usr/lib/libjemalloc.so.2"
ADD test.sh /
CMD ["bash", "/test.sh"]
