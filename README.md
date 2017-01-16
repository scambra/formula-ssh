# OpenSSH Saltstack Formula

Manage installations openssh server and client. Mine host and public keys and make them available to specific minions.

There are more configurable files per client / server, see https://en.wikibooks.org/wiki/OpenSSH/Client_Configuration_Files#.2Fetc.2Fssh.2Fssh_known_hosts
However we dont see a reason to manage all of them. We dont use `/etc/ssh/rc`, if the usecase arises, we will add it.


## Features first run

### Client:
- install client
- client wide /etc/ssh/ssh_config
- $HOME/.ssh/
  - config
  - authorized_keys from pillar given
  - environment <= FOO=bar
  - generate id_rsa / pub or take from pillar
  - known_hosts by getting target hosts from pillars

- mine:
  - $HOME/.ssh/id_rsa.pub



### Server
- /etc/ssh/sshd_config
- /etc/default/ssh
- /etc/ssh/banner

- mine:
  - /etc/ssh/ssh_host_dsa_key      /etc/ssh/ssh_host_ecdsa_key.pub    /etc/ssh/ssh_host_rsa_key
    /etc/ssh/ssh_host_dsa_key.pub  /etc/ssh/ssh_host_ed25519_key      /etc/ssh/ssh_host_rsa_key.pub
    /etc/ssh/ssh_host_ecdsa_key    /etc/ssh/ssh_host_ed25519_key.pub



## Features second run (after generated data has been mined)

### Client:
- $HOME/.ssh/authorized_keys_salt_mined from mine
=> specify in sshd_config: AuthorizedKeysFile

- $HOME/.ssh/known_hosts_salt_mined from mine
=> specify in ssh_config: UserKnownHostsFile

