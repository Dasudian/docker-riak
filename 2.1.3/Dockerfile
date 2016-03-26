# This is a Dockerfile to build a riak database image.
FROM buildpack-deps:trusty-curl
MAINTAINER Mengz <mz@dasudian.com>

ENV DEBIAN_FRONTEND "noninteractive"
ENV RIAK_VERSION "2.1.3-1"

ADD gpg.key /gpg.key

RUN cat gpg.key | apt-key add - \
    && apt-get update \
    && apt-get install -y --no-install-recommends apt-transport-https supervisor \
    && echo "deb https://packagecloud.io/basho/riak/ubuntu/ trusty main" >> /etc/apt/sources.list.d/basho_riak.list \
    && echo "deb-src https://packagecloud.io/basho/riak/ubuntu/ trusty main" >> /etc/apt/sources.list.d/basho_riak.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends riak=$RIAK_VERSION \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD supervisord-riak.conf /etc/supervisor/conf.d/supervisord-riak.conf
ADD riak.conf /etc/riak/riak.conf

EXPOSE 8087 8098

VOLUME ["/var/lib/riak", "/var/log/riak"]

ENTRYPOINT ["riak"]
CMD ["console"]
