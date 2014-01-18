{%- from 'maven/settings.sls' import maven with context %}

{{ maven.prefix }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755

unpack-mvn-tarball:
  cmd.run:
    - name: curl -L '{{ maven.source_url }}' | tar xz
    - cwd: {{ maven.prefix }}
    - unless: test -d {{ maven.real_home }}

apache-maven-home-link:
  alternatives.install:
    - link: {{ maven.m2_home }}
    - path: {{ maven.real_home }}
    - priority: 30
