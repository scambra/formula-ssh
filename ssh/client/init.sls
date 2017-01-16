{% set ssh = salt['pillar.get']('ssh') %}


# Install ssh client package
ssh_client_package:
  pkg.installed:
    - name: openssh-client


# Manage the /etc/ssh/ssh_config global ssh user config
ssh_client_/etc/ssh/ssh_config:
  file.managed:
    - name: /etc/ssh/ssh_config
    - source: salt://ssh/client/files/ssh_config.jinja2
    - template: jinja
    - context:
        config: {{ ssh['client']['config'] }}


# Manage the client config files per user
{% for user in ssh['client'].get('users', {}) %}

    {% set user_home = salt['user.info'](user).get('home', '/home/' + user) %}

# Manage the presence of the ~/.ssh directory
ssh_client_directory_{{ user }}:
  file.directory:
    - name: {{ user_home }}/.ssh
    - user: {{ user }}
    - group: {{ user }}
    - mode: 700


    # Iterate over the authorized users to set up for this user
    {% if ssh['client']['users'][user].get('authorized_keys', False) %}
        {% for authorized_user in ssh['client']['users'][user]['authorized_keys'].get('pillar', {}) %}

            {% set public_key = ssh['client']['users'][user]['authorized_keys']['pillar'][authorized_user]['key'] %}
            {% set public_key_state = ssh['client']['users'][user]['authorized_keys']['pillar'][authorized_user].get('state', 'present') %}

# Manage $HOME/.ssh/authorized_keys from pillar data
ssh_client_authorized_keys_pillar_{{ user }}_authorize_{{ authorized_user }}:
  ssh_auth.{{ public_key_state }}:
    - name: {{ public_key }}
    - user: {{ user }}
    - config: {{ user_home }}/.ssh/authorized_keys

        {% endfor %} 
    {% endif %}


# Manage $HOME/.ssh/environment
ssh_client_{{ user }}_environment:
  file.managed:
    - name: {{ user_home }}/.ssh/environment
    - source: salt://ssh/client/files/environment.jinja2
    - template: jinja
    - user: {{ user }}
    - mode: 600
    - context:
        config: {{ ssh['client']['users'][user].get('environment', {}) }}

# Manage $HOME/.ssh/config
ssh_client_{{ user }}_config:
  file.managed:
    - name: {{ user_home }}/.ssh/config
    - source: salt://ssh/client/files/ssh_config.jinja2
    - template: jinja
    - user: {{ user }}
    - mode: 600
    - context:
        config: {{ ssh['client']['users'][user].get('config', {}) }}


# Manage $HOME/.ssh/id_rsa and id_rsa.pub

    {% if ssh['client']['users'][user].get('keypair', 'generate') == 'generate' %}

ssh_client_keypair_{{ user }}_generate:
  cmd.run:
    - name: ssh-keygen -q -N '' -f {{ user_home}}/.ssh/id_rsa
    - runas: {{ user }}
    - unless: test -f /home/helen/.ssh/id_rsa

    {% elif ssh['client']['users'][user]['keypair'].get('private', False) %}
        {% for key_file_type in ssh['client']['users'][user]['keypair']['private'] %}

ssh_client_keypair_{{ user }}_pillar_{{ key_file_type }}:
  file.managed:
    - name: {{ user_home }}/.ssh/{{ key_file_type }}:
    - contents_pillar: ssh:users:{{ user }}:keypair:{{ key_file_type }}
    - user: {{ user }}
    - group: {{ group }}
    - mode: 600

        {% endfor %}
    {% endif %}




# Manage $HOME/.ssh/known_hosts

    {% if ssh['client']['users'][user].get('known_hosts', False) %}
        {% if ssh['client']['users'][user]['known_hosts'].get('pillar', False) %}
            {% for pillar_known_host in ssh['client']['users'][user]['known_hosts']['pillar'] %}
                {% set pillar_known_host_state = ssh['client']['users'][user]['known_hosts']['pillar'][pillar_known_host] %}

# Uses the following ssh command to automatically accept the host key:
# ssh -oStrictHostKeyChecking=no root@host.example.com /bin/true
ssh_client_known_hosts_{{ user }}_{{ pillar_known_host }}:
  ssh_known_hosts.{{ pillar_known_host_state }}:
    - name: {{ pillar_known_host }}
    - user: {{ user }}

            {% endfor %}
        {% endif %}
    {% endif %}


{% endfor %}
