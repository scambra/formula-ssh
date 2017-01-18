ssh:
  client:


    # Send all managed ssh public keys by default to the salt mine
    mine_pub_key_default: True

    # Setup /etc/ssh/ssh_config, the default ~/.ssh/config for all users
    config:
      'Host *':
        SendEnv: 'LANG LC_*'
        HashKnownHosts: 'yes'
        GSSAPIAuthentication: 'yes'
        GSSAPIDelegateCredentials: 'no'


    # Manage ssh setups for Linux users
    users:

      root:
        # Generate a SSH keypair (which is the default if not given)
        # The public key will be mined
        keypair: generate

        # If you do not want to mine the ssh public key for this user, set this to False
        # True or False, default: True
        mine_keypair: False

        environment:
          SOME: VARIABLE

        # Manage $HOME/.ssh/config
        config:
          'sat.github.com':
            HostName: 'github.com'
            User: git
            IdentityFile: ~/.ssh/id_ed25519_sat
            IdentitiesOnly: 'yes'

        # Populate authorized_keys
        authorized_keys:
          # From pillars
          pillar:
            # A generic name for this dictionary
            peter:
              key: 'command="/usr/bin/echo foobar" ssh-rsa ABCDEFG peter@example.com'
              # present or absent, default: present
              state: present

          # From the mined public keys
          mined:
            peter:
              # Matches the last part of the key
              match: 'backuppc@backup.example.com'
              # prepend something to the public key
              prepend: 'command="/usr/bin/echo foobar"'
              

        # Populate known_hosts
        known_hosts:
          # This will attempt to attemt to ssh to the host
          # This could also be done with the mine - however this much simpler version can be used in all cases
          # If you cant ssh to a host - you dont need to set up ssh for it :)
          # present or absent
          github.com: present
          git.example.com: absent



      backuppc:
        # If keypair is not defined or keypair != generate
        # The public key will also be mined!
        keypair:
          'id_rsa.pub': 'ssh-rsa asdfasdfsadf backuppc@backup.example.com'
          'id_rsa': |
            -----BEGIN RSA PRIVATE KEY-----
            -----END RSA PRIVATE KEY-----

        
        
