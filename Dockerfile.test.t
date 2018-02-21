ADD app /tmp/app
ENV LD_PRELOAD="/usr/lib/libjemalloc.so.2"
CMD ["/bin/herokuish", "test"]
