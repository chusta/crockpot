FROM ubuntu:16.04

ENV COWRIE_REPO https://github.com/micheloosterhof/cowrie
ENV PYTHONPATH /cowrie

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    python-dev \
    python-pip \
    python-setuptools \
    libmpfr-dev \
    libssl-dev \
    libmpc-dev \
    libffi-dev && \
  rm -rf /var/lib/apt/lists/*

RUN adduser cowrie --home /cowrie --shell /bin/false --disabled-pasword --no-create-home

RUN git clone --depth 1 ${COWRIE_REPO} /cowrie && \
    pip install -r /cowrie/requirements.txt --upgrade --no-cache-dir && \
    mkdir -p /data/download && chown -R cowrie:cowrie /data /cowrie

USER cowrie
WORKDIR /cowrie

COPY [ "cowrie.cfg", "/cowrie/" ]

CMD [ "twistd", "--nodaemon", "-l", "/data/cowrie.log", "--umask", "0077", "--pidfile", "var/run/cowrie.pid", "cowrie" ]
