# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

    {%- if grains.os_family == 'MacOS' %}

maven-package-install-cmd-run-brew:
  cmd.run:
    - name: brew install {{ maven.pkg.name }}
    - runas: {{ maven.rootuser }}
    - onlyif: test -x /usr/local/bin/brew

maven-package-reinstall-cmd-run-brew:
  cmd.run:
    - name: brew reinstall {{ maven.pkg.name }}
    - runas: {{ maven.rootuser }}
    - unless: test -x /usr/local/bin/mvn  # if binary is missing

    {%- endif %}
