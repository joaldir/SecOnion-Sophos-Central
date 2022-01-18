{% set MANAGER = salt['grains.get']('master') %}
{% set MANAGER_URL = salt['pillar.get']('global:url_base', '') %}
{% set MANAGER_IP = salt['pillar.get']('global:managerip', '') %}

sophoscentraldir:
  file.directory:
    - name: /opt/so/conf/sophos-central
    - user: 1002
    - group: 1002
    - makedirs: True

so-sophos-central:
  docker_container.running:
    - image: joaldir/so-sophos-siem
    - hostname: sophos-central
    - name: so-sophos-central
    - environment:
      - SOPHOSSI_HOST=0.0.0.0
      - SOPHOSSI_PORT=5678
      - SUBFOLDER=sophossiem
      - N8N_PATH=/sophossiem/
      - DATA_FOLDER=/root/sophossiem/
    - binds:
      - /opt/so/conf/sophossiem:/home/sophossiem/.sophossiem:rw
      - /opt/sophos/config.ini:/opt/Sophos-Central-SIEM-Integration/config.ini:root
      - /opt/sophos/state:/opt/Sophos-Central-SIEM-Integration/state
      - /opt/sophos/log:/opt/Sophos-Central-SIEM-Integration/log
    - extra_hosts:
      - {{MANAGER_URL}}:{{MANAGER_IP}}
