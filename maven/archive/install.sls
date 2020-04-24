# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

maven-package-archive-install:
  pkg.installed:
    - names: {{ maven.pkg.deps|json }}
  file.directory:
    - name: {{ maven.pkg.archive.name }}
    - user: {{ maven.identity.rootuser }}
    - group: {{ maven.identity.rootgroup }}
    - mode: 755
    - makedirs: True
    - clean: True
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    {{- format_kwargs(maven.pkg.archive) }}
    - retry: {{ maven.retry_option|json }}
    - user: {{ maven.identity.rootuser }}
    - group: {{ maven.identity.rootgroup }}
    - require:
      - pkg: maven-package-archive-install
      - file: maven-package-archive-install

    {%- if maven.linux.altpriority|int == 0 or grains.os_family in ('Arch', 'MacOS',)  %}

maven-archive-install-file-symlink-maven:
  file.symlink:
    - name: /usr/local/bin/mvn
    - target: {{ maven.path }}/{{ maven.command }}
    - force: True
    - onlyif: test -f {{ maven.path }}/{{ maven.command }}

    {%- endif %}
