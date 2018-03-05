# -*- mode: dockerfile -*-
ADD app /tmp/build
RUN echo -n heroku-16 > /tmp/env/STACK
RUN /bin/herokuish buildpack build \
 && /bin/herokuish slug generate
