# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

maven-package-clean-cmd-run-brew:
  cmd.run:
    - name: brew uninstall {{ maven.pkg.name }}
    - runas: {{ maven.rootuser }}
    - onlyif: test -x /usr/local/bin/brew

    {%- endif %}
