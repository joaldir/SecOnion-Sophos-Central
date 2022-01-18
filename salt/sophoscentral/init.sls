{% set MANAGER = salt['grains.get']('master') %}
{% set MANAGER_URL = salt['pillar.get']('global:url_base', '') %}
{% set MANAGER_IP = salt['pillar.get']('global:managerip', '') %}

sophossiemdir:
  file.directory:
    - name: /opt/so/conf/sophos-siem
    - user: 1002
    - group: 1002
    - makedirs: True

so-sophos-siem:
  docker_container.running:
    - image: joaldir/so-sophos-siem
    - hostname: sophos-siem
    - name: so-sophos-siem
    - environment:
      - SOPHOSSI_HOST=0.0.0.0
      - SOPHOSSI_PORT=5678
      - SUBFOLDER=sophossiem
      - N8N_PATH=/sophossiem/
      - DATA_FOLDER=/root/sophossiem/
    - binds:
      - /opt/so/conf/sophossiem:/home/sophossiem/.sophossiem:rw
    - extra_hosts:
      - {{MANAGER_URL}}:{{MANAGER_IP}}
