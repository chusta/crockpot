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
* external/dmz honeypots
* internal network canaries
```
          HONEYPOT                        COLLECTOR
+------+------+------+------+       +--------------------+
| hpot | hpot | hpot | hpot |       |       kibana       |
+------+------+------+------+       +--------------^-----+
|         /honeypot         |       |   elasticsearch    |
+------v------+-------------+       +---------+----^-----+
|  logstash   >   ssh-tun   | <---> | ssh-tun > logstash |
+-------------+-------------+       +---------+----------+
```

#### Transport
* During provisioning SSH keys are generated for tunnels initiated by collector.
* Honeypot's logstash exports all log contents to its local tunnel endpoint.
* Collector's logstash ingests honeypot exports through its local tunnel endpoint.
* Collector logstash aggregates multiple (honeypot) inputs into elasticsearch.
* At this point, it can be passed to another system (SIEM) or analyzed (Kibana).

#### Honeypots
* Cowrie
* Glastopf
* Dionaea
* HoneyTrap

#### Files/Directories
* `./resources/*` - contains docker configs for each honeypot.
* `./resources/keys/HOST/*` - SSH auth and tunnel keys.
NOTE: Re-deploying honeypots will re-use keys in the `./resources` folder.

## Installation

#### Requirements
* Ubuntu 16.04
* Install [Ansible](https://www.ansible.com/)
* (optional) Install [Vagrant](https://www.vagrantup.com/)
```
./scripts/install.sh
```

#### Configuration
* Enable remote systems for ansible management.
  - Use `./scripts/bootstrap.sh` for Ubuntu systems.
  - Change SSHd to non-conflicting port (ex: 65535)
* Add SSH host keys for remote systems.
* Add hosts into `hosts` file.
* Verify/backup `./resources` for existing Crockpot configs/artifacts.

#### Deploy
Once the above changes are made, run:
```
ansible-playbook crockpot.yml
```
You'll be good to go! (hopefully)

NOTE: Changing the cowrie ports to more sensible values, such as
TCP/2222 -> TCP/22 or TCP/2323 -> TCP/23, requires additional steps.

See the section "Deploy (2) - The Electric Boogaloo", before deploying Crockpot.

#### Deploy (2)
The `group_vars/all.yml` file contains some variables that affect port
assignment of honeypot services and the VM's SSHd configuration. The goal was to
centralize a bulk of the configuration changes, and (relatively) simplify the process.

As of this writing, the default `group_vars/all.yml` should look something like:
```
  mgmt_port: 22

  cowrie_ssh: 2222
  cowrie_telnet: 2323
```
* `mgmt_port` - SSHd port
* `cowrie_ssh` - Cowrie honeypot SSH port
* `cowrie_telnet` - Cowrie honeypot Telnet port

Changing the Cowrie SSH port will cause a conflict, and prevent the container from
starting up. Before deploying the `crockpot.yml` playbook, modify the `mgmt_port`,
`cowrie_ssh` and `cowrie_telnet`.

The new group_vars file could look like:
```
  mgmt_port: 12345

  cowrie_ssh: 22
  cowrie_telnet: 23
```
Upon deploying Crockpot, all the pertinent port details should be templated into
the docker-compose.yml and SSHd config files. You can verify this in
`/etc/ssh/sshd_config` and `/honeypot/docker-compose.yml`.

It is important to note that the changes themselves will not be applied until
the following components are restarted, across all systems (collector/honeypots):
- SSH service
- SSH tunnels
- Docker containers

The easiest way to get back up and running is to simply restart everything:
```
ansible -a "shutdown -r -t 0" all
```

Once restarted, don't forget to modify the `ansible_port` variable in `hosts`,
otherwise you won't be able to manage your systems with Ansible.
```
[crockpot:vars]
port=12345
```

## Usage

#### Kibana Dashboard
To view the Kibana dashboard, an SSH-tunnel must be established for port forwarding.

* For persistent access, install `autossh`
Example: SSH forwarding for Kibana (TCP/5601) and Elasticsearch (TCP/9200)
```
autossh -M 0 USER@COLLECTOR_ADDR -p22 -L 25601:localhost:5601 -N &
autossh -M 0 USER@COLLECTOR_ADDR -p22 -L 29200:localhost:9200 -N &
```

NOTE: Change the autossh port to reflect the mgmt_port value, if the steps in
"Deploy (2)" have been performed.

## Vagrant
Vagrant configuration exists primarily for development and/or testing.
```
vagrant up
```
This process attempts to standardize the production and dev/test environments.
