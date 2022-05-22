# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import wireguard with context %}

include:
  - {{ sls_config_file }}

{%- set interfaces = wireguard.get('interfaces', {}).keys() %}

{%- if 'init' in grains and grains['init'] == 'systemd' %}
{%-   for interface in interfaces %}
wireguard-service-running-service-running-{{ interface }}:
  service.running:
    - name: {{ wireguard.service.name }}@{{ interface }}
    - enable: True
    - watch:
      - sls: {{ sls_config_file }}
      - file: wireguard-config-file-interface-{{ interface }}-config
  cmd.run:
    - names:
      - journalctl -xeu {{ wireguard.service.name }}@{{ interface }}
      - systemctl status {{ wireguard.service.name }}@{{ interface }}
    - onfail:
      - service: wireguard-service-running-service-running-{{ interface }}
{%-   endfor %}
{%- endif %}

{%-  if grains['os_family'] == 'FreeBSD' %}

wireguard-service-running-sysrc-managed:
  sysrc.managed:
    - name: wireguard_interfaces
    - value: "{{ interfaces|join(' ') }}"

# wireguard-service-running-service-enabled:
#   service.enabled:
#     - name: {{ wireguard.service.name }}

wireguard-service-running-service-running:
  service.running:
    - name: {{ wireguard.service.name }}
    - enable: True
    # - sig: wireguard-go
    # - sig: wg-quick
    # - sig: wg0
    - watch:
      - sysrc: wireguard-service-running-sysrc-managed
      # - service: wireguard-service-running-service-enabled
      - sls: {{ sls_config_file }}
{%-   for interface in interfaces %}
      - file: wireguard-config-file-interface-{{ interface }}-config
{%-   endfor %}
{%- endif %}
