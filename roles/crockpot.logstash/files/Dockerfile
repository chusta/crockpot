FROM ubuntu:16.04
ENV LOGSTASH_GPG 46095ACC8548582C1A2699A9D27D666CD88E42B4

USER root

RUN mkdir -p /crockpot/logstash

RUN apt update && apt install -y \
  apt-transport-https \
  ca-certificates \
  default-jre-headless

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "${LOGSTASH_GPG}" && \
    gpg --export "${LOGSTASH_GPG}" > /etc/apt/trusted.gpg.d/elastic.gpg

RUN echo 'deb https://artifacts.elastic.co/packages/5.x/apt stable main' > /etc/apt/sources.list.d/elastic.list

RUN apt update && apt install -y logstash

VOLUME ["/crockpot/logstash"]

USER logstash

CMD ["/usr/share/logstash/bin/logstash", "--path.settings", "/etc/logstash", "-f", "/crockpot/logstash"]
