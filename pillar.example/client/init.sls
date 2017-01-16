ssh:

  client:

    config:
      'Host *':
        SendEnv: 'LANG LC_*'
        HashKnownHosts: 'yes'
        GSSAPIAuthentication: 'yes'
        GSSAPIDelegateCredentials: 'no'

    users:

      root:
        # Generate a SSH keypair (which is the default if not given)
        # The public key will be mined
        keypair: generate

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
          mine:
            peter:
              # Matches the last part of the key
              match: 'backuppc@backup.example.com'
              # prepend something to the public key
              prepend: 'command="/usr/bin/echo foobar"'
              

        # Populate known_hosts
        known_hosts:
          # From pillars by ssh connecting to hosts and accepting the keys
          pillar:
            # present or absent
            github.com: present
          # From the mined public keys
          mine:
            web.tinc.example.com: present



      backuppc:
        # If keypair is not defined or keypair != generate
        # The public key will also be mined!
        keypair:
          'id_rsa.pub': 'ssh-rsa asdfasdfsadf backuppc@backup.example.com'
          'id_rsa': |
            -----BEGIN RSA PRIVATE KEY-----
            -----END RSA PRIVATE KEY-----

        
        
