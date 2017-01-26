# crockpot
modular honeypots with docker containers

## Overview

### provision
ansible

### transport
ssh tunnels

### systems

#### honeypots

##### services
* honeypots
* logstash (container)

##### files/directories
* `/crockpot`
  - contains Dockerfiles
  - crockpot-specific configs/logs

* `/crockpot/logstash`
  - docker volume -> logstash
  - contains honeypot-specific logstash configs

* `/honeypot/$POT`
  - docker volume -> honeypot
  - honeypot base directory

* `/honeypot/$POT/logs`
  - docker volume -> honeypot
  - contains honeypot logs
  - contents read by logstash container

* `/honeypot/$POT/cfgs`
  - docker volume -> honeypot
  - contains honeypot configs

#### collector

##### services
* elasticsearch
* kibana
* logstash (container)

##### files/directories
* `/crockpot/logstash`
  - docker volume -> logstash
  - contains logstash configs

## Installation

## Usage
