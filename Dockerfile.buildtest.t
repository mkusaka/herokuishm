# -*- mode: dockerfile -*-
ADD app /tmp/build
RUN /bin/herokuish buildpack build \
 && /bin/herokuish slug generate
