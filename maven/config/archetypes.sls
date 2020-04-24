# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

    {%- if 'archetypes_url' in maven and maven.archetypes_url %}
           {%- if maven.pkg.use_upstream_package %}
                  {%- set sls_package_install = tplroot ~ '.package' %}
           {%- elif maven.pkg.use_upstream_archive %}
                  {%- set sls_package_install = tplroot ~ '.archive' %}
           {%- endif %}
include:
  - {{ sls_package_install }}

maven-config-file-managed-archetypes_file:
  cmd.run:
    - name: curl -Lo {{ maven.dir.homes }}/{{ maven.archetypes_file }} {{ maven.archetypes_url }}
  file.managed:
    - name: {{ maven.archetypes_file }}
    - replace: False
    - mode: 644
    - user: {{ maven.identity.rootuser }}
    - group: {{ maven.identity.rootgroup }}
    - makedirs: True
    - require:
      - sls: {{ sls_package_install }}

    {%- endif %}
