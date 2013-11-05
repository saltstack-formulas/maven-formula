{%- set mvn            = salt['pillar.get']('mvn', {}) %}
{%- set version        = mvn.get('version', '3.1.1') %}
{%- set source         = mvn.get('source', '') %}
{%- set source_hash    = mvn.get('source_hash', '') %}
{%- set version_name   = 'apache-maven-' + version %}
{%- set tgz            = version_name + '-bin.tar.gz' %}
{%- set tgz_path       = '/tmp/' + tgz %}
{%- set m2_home        = mvn.get('m2_home', '/usr/lib/apache-maven') %}
{%- set prefix         = mvn.get('prefix', '/usr/share/apache-maven') %}
{%- set m2_real_home   = prefix + '/' + version_name %}

{{ prefix }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755

{{ tgz_path }}:
  file.managed:
{%- if source %}
    - source: {{ source }}
    - source_hash: {{ source_hash }}
{%- else %}
    - source: salt://mvn/files/{{ tgz }}
{%- endif %}

unpack-mvn-tarball:
  cmd.run:
    - name: tar xzf {{ tgz_path }}
    - cwd: {{ prefix }}
    - unless: test -d {{ m2_real_home }}
    - require:
      - file.directory: {{ prefix }}
      - file.managed: {{ tgz_path }}
  alternatives.install:
    - name: apache-maven-home-link
    - link: {{ m2_home }}
    - path: {{ m2_real_home }}
    - priority: 30
    - require:
      - file.directory: {{ prefix }}

jdk-config:
  file.managed:
    - name: /etc/profile.d/apache-maven.sh
    - source: salt://mvn/apache-maven.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      m2_home: {{ m2_home }}

