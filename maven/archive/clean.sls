# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

maven-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ maven.path }}
      - /usr/local/bin/maven
