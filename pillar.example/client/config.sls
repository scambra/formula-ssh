ssh:
  client:

    # Setup /etc/ssh/ssh_config, the default ~/.ssh/config for all users
    config:
      'Host *':
        SendEnv: 'LANG LC_*'
        HashKnownHosts: 'yes'
        GSSAPIAuthentication: 'yes'
        GSSAPIDelegateCredentials: 'no'
