ssh:
  client:

    # Setup /etc/ssh/ssh_config, the default ~/.ssh/config for all users
    config:
      'Host *':
        SendEnv: 'LANG LC_*'
        HashKnownHosts: 'yes'
        GSSAPIAuthentication: 'yes'
        GSSAPIDelegateCredentials: 'no'
        ForwardAgent: 'no'
        ForwardX11: 'no'
        ForwardX11Trusted: 'yes'
        RhostsRSAAuthentication: 'no'
        RSAAuthentication: 'yes'
        PasswordAuthentication: 'yes'
        HostbasedAuthentication: 'no'
        GSSAPIKeyExchange: 'no'
        GSSAPITrustDNS: 'no'
        BatchMode: 'no'
        CheckHostIP: 'yes'
        AddressFamily: any
        ConnectTimeout: 0
        StrictHostKeyChecking: ask
        IdentityFile:
          - '~/.ssh/identity'
          - '~/.ssh/id_rsa'
          - '~/.ssh/id_dsa'
        Port: 22
        Protocol: '2,1'
        Cipher: 3des
        Ciphers: aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128,aes128-cbc,3des-cbc
        MACs: 'hmac-md5,hmac-sha1,umac-64@openssh.com,hmac-ripemd160'
        EscapeChar: '~'
        Tunnel: 'no'
        TunnelDevice: 'any:any'
        PermitLocalCommand: 'no'
        VisualHostKey: 'no'
        ProxyCommand: 'ssh -q -W %h:%p gateway.example.com'
        RekeyLimit: '1G 1h'
