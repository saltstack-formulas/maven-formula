# -*- coding: utf-8 -*-
# vim: ft=sls

    {% if grains.kernel|lower == 'linux' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

          {% if maven.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

maven-linuxenv-home-alternatives-install:
  alternatives.install:
    - name: {{ maven.pkg.name }}home
    - link: /opt/{{ maven.pkg.name }}
    - path: {{ maven.path }}
    - priority: {{ maven.linux.altpriority }}
    - retry: {{ maven.retry_option|json }}

maven-linuxenv-home-alternatives-set:
  alternatives.set:
    - name: {{ maven.pkg.name }}home
    - path: {{ maven.path }}
    - onchanges:
      - alternatives: maven-linuxenv-home-alternatives-install
    - retry: {{ maven.retry_option|json }}

maven-linuxenv-executable-alternatives-install:
  alternatives.install:
    - name: {{ maven.pkg.name }}
    - link: {{ maven.linux.symlink }}
    - path: {{ maven.path }}/{{ maven.command }}
    - priority: {{ maven.linux.altpriority }}
    - require:
      - alternatives: maven-linuxenv-home-alternatives-install
      - alternatives: maven-linuxenv-home-alternatives-set
    - retry: {{ maven.retry_option|json }}

maven-linuxenv-executable-alternatives-set:
  alternatives.set:
    - name: {{ maven.pkg.name }}
    - path: {{ maven.path }}/{{ maven.command }}
    - onchanges:
      - alternatives: maven-linuxenv-executable-alternatives-install
    - retry: {{ maven.retry_option|json }}

          {%- else %}

maven-linuxenv-alternatives-install-unapplicable:
  file.symlink:
    - name: /opt/{{ maven.pkg.name }}
    - target: {{ maven.path }}
    - onlyif: test -d {{ maven.path }}
    - force: True
  test.show_notification:
    - text: |
        Linux alternatives are turned off (maven.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.

          {% endif %}
    {% endif %}
