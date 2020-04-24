# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}
{%- set sls_package_install = tplroot ~ '.maven.package.install' %}
{%- set sls_source_install = tplroot ~ '.maven.source.install' %}

    {%- if 'config' in maven and maven.config %}
        {%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  {{ '- ' + sls_package_clean if maven.pkg.use_upstream_repo else '' }}
  {{ '- ' + sls_binary_clean if maven.pkg.use_upstream_binary else '' }}

maven-config-file-install-file-managed:
  file.managed:
    - name: {{ maven.config_file }}
    - source: {{ files_switch(['config.yml.jinja'],
                              lookup='maven-config-file-install-file-managed'
                 )
              }}
    - mode: 644
    - user: {{ maven.rootuser }}
    - group: {{ maven.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
      orgdomain: {{ maven.config.orgdomain }}
      scmhost: {{ maven.config.scmhost }}
      repohost: {{ maven.config.repohost }}
    - require:
      {{ '- sls: ' + sls_package_install if maven.pkg.use_upstream_repo else '' }}
      {{ '- sls: ' + sls_binary_install if maven.pkg.use_upstream_binary else '' }}

    {%- endif %}
