# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

    {%- if grains.os_family == 'MacOS' %}

maven-package-install-cmd-run-brew:
  cmd.run:
    - name: brew install maven
    - runas: {{ maven.identity.rootuser }}
    - onlyif: test -x /usr/local/bin/brew

maven-package-reinstall-cmd-run-brew:
  cmd.run:
    - name: brew reinstall maven
    - runas: {{ maven.identity.rootuser }}
    - unless: test -x /usr/local/bin/mvn  # if binary is missing

    {%- else %}

maven-not-available-to-install:
  test.show_notification:
    - text: |
        Maybe you wanted to install from archive (maven.pkg.use_upstream_archive=true)
        Otherwise no maven package is available for {{ salt['grains.get']('finger', grains.os_family) }}

    {%- endif %}
