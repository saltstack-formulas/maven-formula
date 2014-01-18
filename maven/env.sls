{%- from 'maven/settings.sls' import maven with context %}

/etc/profile.d/apache-maven.sh:
  file.managed:
    - source: salt://maven/apache-maven.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      m2_home: {{ maven.m2_home }}
