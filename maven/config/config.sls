#  -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

    {%- if 'config' in maven and maven.config %}
           {%- set sls_package_install = tplroot ~ '.package' %}
           {%- set sls_archive_install = tplroot ~ '.archive' %}
           {%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install if maven.pkg.use_upstream_package else sls_archive_install }}

maven-config-file-install-config_managed:
  file.managed:
    - name: {{ maven.dir.homes }}/{{ maven.identity.user }}/{{ maven.config_file }}
    - source: {{ files_switch(['config.yml.jinja'],
                              lookup='maven-config-file-install-config_managed'
                 )
              }}
    - mode: 644
    - user: {{ maven.identity.rootuser }}
    - group: {{ maven.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
      orgdomain: {{ maven.config.orgdomain }}
      scmhost: {{ maven.config.scmhost }}
      repohost: {{ maven.config.repohost }}
    # require:
    # - sls: {{ sls_package_install if maven.pkg.use_upstream_package else sls_archive_install }}

    {%- endif %}
