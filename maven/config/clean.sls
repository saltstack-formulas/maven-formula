# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

    {%- if 'environ' in maven and maven.environ %}
           {%- if maven.pkg.use_upstream_package %}
                  {%- set sls_package_clean = tplroot ~ '.package.clean' %}
           {%- elif maven.pkg.use_upstream_archive %}
                  {%- set sls_package_clean = tplroot ~ '.archive.clean' %}
           {%- endif %}
include:
  - {{ sls_package_clean }}

maven-config-clean-file-absent:
  file.absent:
    - names:
      - /tmp/dummy_list_item
               {%- if maven.config_file %}
      - {{ maven.config_file }}
               {%- endif %}
               {%- if maven.environ_file %}
      - {{ maven.environ_file }}
               {%- endif %}
               {%- if maven.archetypes_file %}
      - {{ maven.archetypes_file }}
               {%- endif %}
    - require:
      - sls: {{ sls_package_clean }}
