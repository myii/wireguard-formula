# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import wireguard with context %}

{%- set pkgs = wireguard.pkg.dependencies + [wireguard.pkg.name] %}

wireguard-package-install-pkg-installed:
  pkg.installed:
    - pkgs: {{ pkgs }}
