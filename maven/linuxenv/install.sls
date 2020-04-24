# -*- coding: utf-8 -*-
# vim: ft=sls

    {% if grains.kernel|lower == 'linux' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

          {% if maven.linux.ldconfig %}

maven-linuxenv-oracle-conf-file-managed:
  pkg.installed:
    - name: {{ maven.pkg.libaio }}
  file.managed:
    - name: /etc/ld.so.conf.d/oracle.conf
    - mkdirs: True
    - require:
      - file: maven-linuxenv-package-installed
    - onlyif: test -d {{ maven.path }}

maven-linuxenv-ld-so-conf-file:
  file.append:
    - name: /etc/ld.so.conf.d/oracle.conf
    - text: {{ maven.path }}/client64/lib
    - require:
      - file: maven-linuxenv-oracle-conf-file-managed
  cmd.run
    - name: ldconfig
    - require:
      - file: maven-linuxenv-ld-so-conf-file

          {% endif %}
          {% if maven.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

maven-linuxenv-home-alternatives-install:
  alternatives.install:
    - name: mavenhome
    - link: /opt/maven
    - path: {{ maven.path }}
    - priority: {{ maven.linux.altpriority }}
    - retry: {{ maven.retry_option|json }}

maven-linuxenv-home-alternatives-set:
  alternatives.set:
    - name: mavenhome
    - path: {{ maven.path }}
    - onchanges:
      - alternatives: maven-linuxenv-home-alternatives-install
    - retry: {{ maven.retry_option|json }}

maven-linuxenv-executable-alternatives-install:
  alternatives.install:
    - name: maven
    - link: {{ maven.linux.symlink }}
    - path: {{ maven.path }}/{{ maven.command }}
    - priority: {{ maven.linux.altpriority }}
    - require:
      - alternatives: maven-linuxenv-home-alternatives-install
      - alternatives: maven-linuxenv-home-alternatives-set
    - retry: {{ maven.retry_option|json }}

maven-linuxenv-executable-alternatives-set:
  alternatives.set:
    - name: maven
    - path: {{ maven.path }}/{{ maven.command }}
    - onchanges:
      - alternatives: maven-linuxenv-executable-alternatives-install
    - retry: {{ maven.retry_option|json }}

          {%- else %}

maven-linuxenv-alternatives-install-unapplicable:
  file.symlink:
    - name: /opt/maven
    - target: {{ maven.path }}
    - onlyif: test -d {{ maven.path }}
    - force: True
  test.show_notification:
    - text: |
        Linux alternatives are turned off (maven.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.

          {% endif %}
    {% endif %}
