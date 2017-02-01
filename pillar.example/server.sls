ssh:
  server:

    config:
      AllowTcpForwarding: 'no'
      ClientAliveCountMax: 0
      ClientAliveInterval: 0
      HostbasedAuthentication: 'no'
      HostKey:
        - /etc/ssh/ssh_host_dsa_key
        - /etc/ssh/ssh_host_ecdsa_key
        - /etc/ssh/ssh_host_ed25519_key
        - /etc/ssh/ssh_host_rsa_key
      IgnoreRhosts: 'yes'
      KeyRegenerationInterval: 3600
      LoginGraceTime: 60s
      LogLevel: INFO
      PasswordAuthentication: 'no'
      PermitEmptyPasswords: 'no'
      PermitRootLogin: 'without-password'
      Port: 22
      PrintLastLog: 'yes'
      PrintMotd: 'no'
      Protocol: 2
      PubkeyAuthentication: 'yes'
      RhostsRSAAuthentication: 'no'
      RSAAuthentication: 'yes'
      ServerKeyBits: 1024
      StrictModes: 'yes'
      'Subsystem sftp': /usr/lib/openssh/sftp-server
      SyslogFacility: AUTH
      TCPKeepAlive: 'yes'
      UseDNS: 'no'
      UsePAM: 'yes'
      UsePrivilegeSeparation: 'yes'
      X11DisplayOffset: 10
      X11Forwarding: 'no'


    default:
      SSHD_OPTS: ''
