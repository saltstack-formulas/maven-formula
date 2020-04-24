# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

maven-package-clean-cmd-run-brew:
  cmd.run:
    - name: brew uninstall maven
    - runas: {{ maven.identity.rootuser }}
    - onlyif:
      - test -x /usr/local/bin/brew
      - {{ grains.os_family == 'MacOS' }}
