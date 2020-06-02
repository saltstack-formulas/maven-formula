# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.kernel|lower == 'linux' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

maven-linuxenv-home-file-absent:
  file.absent:
    - names:
      - /opt/{{ maven.pkg.name }}
      - {{ maven.path }}

          {%- if maven.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

maven-linuxenv-home-alternatives-clean:
  alternatives.remove:
    - name: {{ maven.pkg.name }}home
    - path: {{ maven.path }}
    - onlyif: update-alternatives --get-selections |grep ^mavenhome

maven-linuxenv-executable-alternatives-clean:
  alternatives.remove:
    - name: {{ maven.pkg.name }}
    - path: {{ maven.path }}/{{ maven.pkg.name }}
    - onlyif: update-alternatives --get-selections |grep ^maven

          {%- else %}

maven-linuxenv-alternatives-clean-unapplicable:
  test.show_notification:
    - text: |
        Linux alternatives are turned off (maven.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.

          {% endif %}
    {% endif %}
