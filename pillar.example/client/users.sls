ssh:
  client:

    # Send all managed ssh public keys to the salt mine by default? (overridable below)
    mine_pub_key_default: True

    # ssh-keygen arguments - omit -f { user_home }, as this is set by the formula
    ssh_keygen_arguments: "-q -N '' -o -a 128 -t ed25519"

    # Filename-base of the keypair files generated with the { ssh_keygen_arguments } specified above
    # The example above will generate a `~/.ssh/id_ed25519.pub` file, hence we specify "id_ed25519"
    ssh_keygen_filename: id_ed25519


    # Manage ssh setups for Linux users
    users:

      # Manage the "root" user
      root:

        # Generate a SSH keypair (which is the default if not given)
        keypair: generate

        # If you do not want to mine the ssh public key for this user, set this to False
        # True or False, default: True
        mine_keypair: True

        # Setup key=value environment variables in ~/.ssh/environment
        environment:
          SOME: VARIABLE

        # Manage $HOME/.ssh/config
        config:
          'sat.github.com':
            HostName: 'github.com'
            User: git
            IdentityFile: '~/.ssh/id_ed25519_sat'
            IdentitiesOnly: 'yes'

        # Populate authorized_keys
        authorized_keys:
          # From pillars
          pillar:
            # A generic name for this dictionary
            peter:
              key: 'command="/usr/bin/echo foobar" ssh-rsa kdsfsakfsajkfsjfk peter@example.com'
              # present or absent, default: present
              state: present
          # From the mined public keys
          mined:
            backuppc:
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


      # Another user
      backuppc:
        # If keypair is not defined or keypair != generate
        # This public key will also be mined if mine_keypair != False
        keypair:
          'id_rsa.pub': 'ssh-rsa asdfasdfsadf backuppc@backup.example.com'
          'id_rsa': |
            -----BEGIN RSA PRIVATE KEY-----
            -----END RSA PRIVATE KEY-----

