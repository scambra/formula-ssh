{% set ssh = salt['pillar.get']('ssh') %}


ssh_server_package:
  pkg.installed:
    - name: openssh-server


ssh_server_sshd_config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://ssh/server/files/sshd_config.jinja2
    - template: jinja
    - context:
        config: {{ ssh['server']['config'] }}
    - user: root
    - group: root
    - mode: 644

ssh_server_/etc/default/ssh:
  file.managed:
    - name: /etc/default/ssh
    - source: salt://ssh/server/files/etc-default-ssh.jinja2
    - template: jinja
    - context:
        config: {{ ssh['server']['default'] }}
    - user: root
    - group: root
    - mode: 644


ssh_server_service:
  service.running:
    - name: ssh
