# OpenSSH Saltstack Formula

Manage installations of the openssh server and client. Mine ssh public keys and configure them on specified minions.

## PENDING ISSUES @ [github.com/saltstack/salt](https://github.com/saltstack/salt)

- Fatal: Using `ssh_auth.present` fails in salt 2016.11.0: [github issue](https://github.com/saltstack/salt/issues/38930)
- Annoying: Using mine.send via module.run does not accept to set a mine ID for the send object: [github issue](https://github.com/saltstack/salt/issues/38800)


## Features

**Client**

- Manage `/etc/ssh/ssh_config`
- Manage `~/.ssh/config`
- Manage `~/.ssh/environment`
- Manage `~/.ssh/known_hosts` by test ssh-ing to the respective host
- Generate `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub` via `ssh-keygen` and push to mine (optional)
- Manage `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub` from pillars and push to mine (optional)
- Manage `~/.ssh/authorized_keys` from pillars
- Manage `~/.ssh/authorized_keys` from mine data

**Server**

- Manage `/etc/ssh/sshd_config`
- Manage `/etc/default/ssh`

There are more configurable files per client / server, see:  
<https://en.wikibooks.org/wiki/OpenSSH/Client_Configuration_Files#.2Fetc.2Fssh.2Fssh_known_hosts>  
However we dont see a reason to manage all of them. We dont use `/etc/ssh/rc`, if the usecase arises, we will add it.


## Formula Usage

**Setup pillar**  
Copy the `pillar.example` directory from this git repository to `/srv/pillar/ssh` and put define it in `/srv/pillar/top.sls`

**Configure mine**  
Configure the mine according to your likings. This formula only sends SSH public keys to the mine, the IDs are named: `ssh_pub_{{ user }}@{{ grains['id'] }}`  
As the pillars allow to define which public keys are actually setup in the authorized_keys files, its ok to give all minions access to all public keys via the mine. Edit `/etc/salt/master.d/mine.conf` and insert the following:
```
mine_get:
  # Target all minions
  .*:
    # Make everything starting with ssh_pub_ available
    - ssh_pub_*
```

**Apply the formula**  
To apply the configuration defined in `/srv/pillar/ssh/`, run:
```
salt 'minion' state.sls ssh
```

## Requirements

This formula requires Linux users, whos client configuration is to be managed, to be present. The [group-and-user](https://github.com/blunix/formula-group-and-user) formula can be used to accomplish this. 

If ssh keys from the SaltStack mine are defined, those have to generated / templated and mined first. An example for a backup server running [backuppc](https://github.com/blunix/formula-backuppc):  
- Configure the pillars to generate a keypair on the machine "backuppc.example.com" for the user "backuppc" and have it pushed to the mine, then run the formula on the "backuppc" machine.
- Setup the public key "backuppc@backup.example.com" in the pillars for the root user for all other minions, then run the formula on all minions.


## Testing in Vagrant

Run the following commands:
```
git clone git@github.com:blunix/vagrant_saltstack.git
cd vagrant_saltstack
vagrant up utility
vagrant ssh utility
sudo -Es
```

In the vagrant box, open `/srv/pillar/top.sls` with your favorite editor add add:
```
base:
  '*'
    - ssh
```

Then open `/etc/salt/master.d/mine.conf` and insert:
```
mine_get:
  .*:
    - ssh_pub_*
```

Run a `service salt-master restart` to apply the changes to the config file. Then take a look at the `.sls` files in `/srv/pillar/ssh` and edit them to your requirements. To refresh the pillars and setup the formula:
```
salt 'utility' saltutil.refresh_pillar
salt 'utility' state.sls ssh
```


# Contributing
Contributions and bug reports are very welcome!

Please follow these steps to get your changes merged by us:

1. Create an issue describing your change in human language
2. File a pull-request linked to that issue.


# Supported Operating-Systems
- Debian 8
- Ubuntu 14.04
- Ubuntu 16.04


# Enterprise Support
Support and consulting for Debian Linux servers and automation of SSH configuration, vagrant development environments, Saltstack and more is available at:

Blunix GmbH - Professional Linux Service  
Web: <a href="https://www.blunix.org/" target="_blank">www.blunix.org</a>  
Mail: <mailto:service@blunix.org>
