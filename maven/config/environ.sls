# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

    {%- if 'environ' in maven and maven.environ %}
           {%- if maven.pkg.use_upstream_package %}
                  {%- set sls_package_install = tplroot ~ '.package' %}
           {%- elif maven.pkg.use_upstream_archive %}
                  {%- set sls_package_install = tplroot ~ '.archive' %}
           {%- endif %}
include:
  - {{ sls_package_install }}

maven-config-file-file-managed-environ_file:
  file.managed:
    - name: {{ maven.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='maven-config-file-file-managed-environ_file'
                 )
              }}
    - mode: 644
    - user: {{ maven.identity.rootuser }}
    - group: {{ maven.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        path: {{ maven.path|json }}
        environ: {{ maven.environ|json }}
    - require:
      - sls: {{ sls_package_install }}

    {%- endif %}
