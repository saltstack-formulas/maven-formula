{%- from 'maven/settings.sls' import maven with context %}

{#- require a source_url - there is no default download location for Maven #}

{%- if maven.source_url is defined %}

  {%- set archive_file = maven.prefix + '/' + maven.source_url.split('/') | last %}

include:
- env

maven-install-dir:
  file.directory:
    - name: {{ maven.prefix }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

# curl fails (rc=23) if file exists
# and test -f cannot detect corrupt archive-file.
maven-remove-prev-archive:
  file.absent:
    - name: {{ archive_file }}
    - require:
      - file: maven-install-dir

maven-download-archive:
  cmd.run:
    - name: curl {{ maven.dl_opts }} -o '{{ archive_file }}' '{{ maven.source_url }}'
    - unless: test -f {{ maven.maven_realcmd }}
    - require:
      - file: maven-remove-prev-archive
    - require_in:
      - archive: maven-unpack-archive

{% if grains['saltversioninfo'] <= [2016, 11, 6] and maven.source_hash %}
    # See: https://github.com/saltstack/salt/pull/41914
maven-check-archive-hash:
  module.run:
    - name: file.check_hash
    - path: {{ archive_file }}
    - file_hash: {{ maven.source_hash }}
    - onchanges:
      - cmd: maven-download-archive
    - require_in:
      - archive: maven-unpack-archive
{%- endif %}

maven-unpack-archive:
  archive.extracted:
    - name: {{ maven.prefix }}
    - source: file://{{ archive_file }}
    - archive_format: {{ maven.archive_type }} 
    - user: root
    - group: root
  {% if grains['saltversioninfo'] > [2016, 11, 6] and maven.source_hash %}
    - source_hash: {{ maven.source_hash }}
  {%- endif %}
  {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - tar_options: {{ maven.unpack_opts }}
    - if_missing: {{ maven.maven_realcmd }}
  {% endif %}
    - require:
      - cmd: maven-download-archive

maven-update-home-symlink:
  file.symlink:
    - name: {{ maven.maven_home }}
    - target: {{ maven.maven_real_home }}
    - force: True
    - require:
      - archive: maven-unpack-archive
    - require_in:
      - alternatives: maven-home-alt-set

maven-remove-archive:
  file.absent:
    - name: {{ archive_file }}
    - require:
      - archive: maven-unpack-archive

  {% if grains['saltversioninfo'] > [2016, 11, 6] and maven.source_hash %}
maven-remove-archive-hash:
  file.absent:
    - name: {{ archive_file }}.sha256
    - require:
      - archive: maven-unpack-archive
  {%- endif %}

{%- endif %}
