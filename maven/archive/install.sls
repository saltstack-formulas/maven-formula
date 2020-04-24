# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

maven-package-archive-install-prepare:
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

    {%- for name in maven.pkg.wanted %}

maven-package-archive-install-{{ name }}:
  archive.extracted:
    - name: {{ maven.pkg.archive.name }}
    - source: {{ maven.pkg.urls[name] }}
    - source_hash: {{ maven.pkg.checksums[name] }}
    - retry: {{ maven.retry_option|json }}
    - user: {{ maven.identity.rootuser }}
    - group: {{ maven.identity.rootgroup }}
    - require:
      - pkg: maven-package-archive-install-prepare
      - file: maven-package-archive-install-prepare

    {%- endfor %}
    {%- if maven.linux.altpriority|int == 0 or grains.os_family not in ('Arch', 'Windows')  %}

maven-archive-install-file-symlink-maven:
  file.symlink:
    - name: /usr/local/bin/maven
    - target: {{ maven.path }}/{{ maven.command }}
    - force: True
    - onlyif: test -f {{ maven.path }}/{{ maven.command }}

    {%- endif %}
