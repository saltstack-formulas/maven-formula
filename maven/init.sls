{%- from 'maven/settings.sls' import maven with context %}

{#- require a source_url - there is no default download location for Maven #}

{%- if maven.source_url is defined %}

  {%- set archive_file = maven.prefix + '/' + maven.source_url.split('/') | last %}

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
    - require:
      - file: maven-remove-prev-archive

maven-unpack-archive:
  archive.extracted:
    - name: {{ maven.prefix }}
    - source: file://{{ archive_file }}
  {% if grains['saltversioninfo'] > [2016, 11, 6] and maven.source_hash %}
    - source_hash: {{ maven.source_hash }}
  {%- endif %}
  {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - if_missing: {{ maven.maven_realcmd }}
  {% endif %}
    - archive_format: {{ maven.archive_type }}
    - onchanges:
      - cmd: maven-download-archive

maven-update-home-symlink:
  file.symlink:
    - name: {{ maven.maven_home }}
    - target: {{ maven.maven_real_home }}
    - force: True
    - require:
      - archive: maven-unpack-archive
    - onchanges:
      - archive: maven-unpack-archive

maven-remove-archive:
  file.absent:
    - names:
      - {{ archive_file }}
      - {{ archive_file }}.sha256
    - require:
      - archive: maven-unpack-archive

{%- endif %}
