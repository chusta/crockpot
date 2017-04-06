# crockpot
containerized honeypots

## Table of Contents
* [Overview](#overview)
  * [Transport](#transport)
  * [Honeypots](#honeypots)
* [Installation](#installation)
  * [Requirements](#requirements)
  * [Configuration](#configuration)
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

#### Transport
- During provisioning SSH keys are generated for tunnels initiated by collector.
- Honeypot's logstash exports all log contents to its local tunnel endpoint.
- Collector's logstash ingests honeypot exports through its local tunnel endpoint.
- Collector logstash aggregates multiple (honeypot) inputs into elasticsearch.
- At this point, it can be passed to another system (SIEM) or analyzed (Kibana).

#### Honeypots
A `honeypot.template` also exists which can be used to add custom honeypots.
- Cowrie
- Glastopf
- Dionaea

#### Files/Directories
NOTE: Re-deploying honeypots will re-use keys in the `./resources` folder.

`./resources/*` - contains docker configs for each honeypot
`./resources/keys/*` - contains ssh tunnel keys
`./resources/sshd/*` - contains sshd service keys

#### TL;DR
Crockpot deploys ephemeral honeypots with a central log collector.

## Installation

#### Requirements
* Ubuntu 16.04
* Install [Ansible](https://www.ansible.com/)
* (optional) Install [Vagrant](https://www.vagrantup.com/)
* (optional) Install [Virtualbox](https://www.virtualbox.org/wiki/Linux_Downloads)

#### Configuration
* Enable remote systems for ansible management.
  - Use `./scripts/bootstrap.sh` for Ubuntu systems.
  - Change SSHd to non-conflicting port (ex: 65535)
* Add SSH host keys for remote systems.
* Add hosts into `hosts` file.
* Verify `./resources` for existing Crockpot configs/artifacts.

#### Deploy
Once the above changes are made, run the `deploy.sh` script.
You'll be good to go! (hopefully)

## Usage

#### Kibana Dashboard
To view the Kibana dashboard, an SSH-tunnel must be established for port forwarding.

* For persistent access, install `autossh`
```
# kibana dashboard
autossh -M 0 USER@COLLECTOR_ADDR -L 25601:localhost:5601 -N &

# elasticsearch
autossh -M 0 USER@COLLECTOR_ADDR -L 29200:localhost:9200 -N &
```

## DevTest
Vagrant configuration exists primarily for testing.

* `vagrant up`

This process attempts to standardize the production and dev/test
environments, making it simpler to make and validate any changes.
