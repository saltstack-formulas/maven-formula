# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

    {%- if grains.kernel|lower in ('linux', 'darwin',) %}
           {%- set sls_package_install = tplroot ~ '.package' %}
           {%- set sls_archive_install = tplroot ~ '.archive' %}
           {%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install if maven.pkg.use_upstream_package else sls_archive_install }}

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
        environ: {{ '' if not maven.environ else maven.environ|json }}
    # require:
    # - sls: {{ sls_package_install if maven.pkg.use_upstream_package else sls_archive_install }}

    {%- endif %}
