# Using these mine functions, the relevant pieces of information are made available to all minions in the respective networks
mine_functions:

# A list of all networks defined in tinc:networks
{% for network_name in ['interconnect'] %}

  # After the tinc.install formula creates the keypair it runs a mine.update
  tinc_{{ network_name }}_rsa_pub:
    mine_function: cmd.run
    cmd: 'cat /etc/tinc/{{ network_name }}/rsa_key.pub 2> /dev/null'
    python_shell: True

  # We can just copy this information from the pillar dict of the respective minion:
  # Subnet and Address
  tinc_{{ network_name }}_subnet:
    mine_function: pillar.get
    key: tinc:networks:{{ network_name }}:config:host_conf:Subnet
  tinc_{{ network_name }}_address:
    mine_function: pillar.get
    key: tinc:networks:{{ network_name }}:config:host_conf:Address

{% endfor %}
