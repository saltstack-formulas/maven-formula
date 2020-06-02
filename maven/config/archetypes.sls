# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

    {%- if 'archetypes_url' in maven and 'http' in maven.archetypes_url %}
           {%- set sls_package_install = tplroot ~ '.package' %}
           {%- set sls_archive_install = tplroot ~ '.archive' %}
           {%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install if maven.pkg.use_upstream_package else sls_archive_install }}

maven-config-file-managed-archetypes_file:
  cmd.run:
    - name: curl -Lo {{ maven.dir.homes }}/{{ maven.identity.user }}/{{ maven.archetypes_file }} {{ maven.archetypes_url }}  # noqa 204
  file.managed:
    - name: {{ maven.archetypes_file }}
    - replace: False
    - mode: 644
    - user: {{ maven.identity.rootuser }}
    - group: {{ maven.identity.rootgroup }}
    - makedirs: True
    - require:
      - sls: {{ sls_package_install if maven.pkg.use_upstream_package else sls_archive_install }}

    {%- endif %}
