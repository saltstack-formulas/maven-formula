# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

    {%- if 'config' in maven and maven.config %}
           {%- set sls_package_clean = tplroot ~ '.package.clean' %}
           {%- set sls_archive_clean = tplroot ~ '.archive.clean' %}
           {%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_clean if maven.pkg.use_upstream_package else sls_archive_clean }}

maven-config-clean-file-absent:
  file.absent:
    - names:
      - /tmp/dummy_list_item
               {%- if maven.config_file %}
      - {{ maven.dir.homes }}/{{ maven.identity.user }}/{{ maven.config_file }}
               {%- endif %}
               {%- if maven.environ_file %}
      - {{ maven.environ_file }}
               {%- endif %}
               {%- if maven.archetypes_file %}
      - {{ maven.dir.homes }}/{{ maven.identity.user }}/{{ maven.archetypes_file }}
               {%- endif %}
    - require:
      - sls: {{ sls_package_clean if maven.pkg.use_upstream_package else sls_archive_clean }}

    {%- endif %}
