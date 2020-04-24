# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.kernel|lower == 'linux' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

          {%- if maven.linux.ldconfig %}

maven-linuxenv-home-file-absent:
  pkg.removed:
    - name: {{ maven.pkg.libaio }}
  file.absent:
    - names:
      - /opt/maven
      - /etc/ld.so.conf.d/oracle.conf
      - {{ maven.path }}

          {%- endif %}
          {%- if maven.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

maven-linuxenv-home-alternatives-clean:
  alternatives.remove:
    - name: mavenhome
    - path: {{ maven.path }}
    - onlyif: update-alternatives --get-selections |grep ^mavenhome

maven-linuxenv-executable-alternatives-clean:
  alternatives.remove:
    - name: maven
    - path: {{ maven.path }}/maven
    - onlyif: update-alternatives --get-selections |grep ^maven

          {%- else %}

maven-linuxenv-alternatives-clean-unapplicable:
  test.show_notification:
    - text: |
        Linux alternatives are turned off (maven.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.

          {% endif %}
    {% endif %}
