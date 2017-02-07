# crockpot
containerized honeypots

## Table of Contents
* [Overview](#overview)
  * [Transport](#transport)
  * [Honeypots](#honeypots)
* [Installation](#installation)
* [Usage](#usage)
* [Details](#details)
* [DevTest](#devtest)

## Overview
The goal of Crockpot was to simplify the deployment of honeypots. Since they are
container-based, the idea is to have ephemeral honeypots on physical boxes,
with the exception of a centralized node, which houses the aggregated log data.

Use cases:
- external/dmz honeypots
- internal network canaries
```
          HONEYPOT
+------+------+------+------+
| hpot | hpot | hpot | hpot |             COLLECTOR
+------+------+------+------+       +--------------------+
|         /honeypot         |       |   elasticsearch    |
+------v------+-------------+       +---------+----^-----+
|  logstash   >   ssh-tun   | <---- | ssh-tun > logstash |
+-------------+-------------+       +---------+----------+
```

## Transport
- During provisioning SSH keys are generated for tunnels initiated by collector.
- Honeypot's logstash exports all log contents to its local tunnel endpoint.
- Collector's logstash ingests honeypot exports through its local tunnel endpoint.
- Collector logstash aggregates multiple (honeypot) inputs into elasticsearch.
- At this point, it can be passed to another system (SIEM) or analyzed (Kibana).

## Honeypots
A `honeypot.template` also exists which can be used to add custom honeypots.
- Cowrie
- Glastopf
- Dionaea

## TL;DR
Crockpot deploys ephemeral honeypots with a central log collector.


# Installation
Crockpot was tested on Ubuntu 16.04 but _should_ work on systems that can run docker.

* Install [Ansible](https://www.ansible.com/)
* (optional) Install [Vagrant](https://www.vagrantup.com/)
* (optional) Install [Virtualbox](https://www.virtualbox.org/wiki/Linux_Downloads)

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

## DevTest
Vagrant configurations exist for both single and multi-system setups.

* Rename `Vagrantfile.single` or `Vagrantfile.multi` to `Vagrantfile`
* `vagrant up`

See associated Vagrantfile for honeypot port forwards. You can test the
honeypot services by connecting to the localhost port, for example:
`ssh root localhost -p 10022` => ssh to `hpot-01` cowrie
`ssh root localhost -p 20022` => ssh to `hpot-02` cowrie

This, hopefully, attempts to standardize the production and dev/test
environments, making it simpler to make and validate any changes.
