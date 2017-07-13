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
{{ archive_file }}:
  file.absent:
    - require_in:
      - maven-download-archive

maven-download-archive:
  cmd.run:
    - name: curl {{ maven.dl_opts }} -o '{{ archive_file }}' '{{ maven.source_url }}'
    - unless: test -d {{ maven.maven_realcmd }}
    - require:
      - file: maven-install-dir
    - require_in:
      - maven-unpack-archive

maven-unpack-archive:
  archive.extracted:
    - name: {{ maven.prefix }}
    - source: file://{{ archive_file }}
    {%- if maven.source_hash %}
    - source_hash: {{ maven.source_hash }}
    {%- endif %}
    - archive_format: {{ maven.archive_type }} 
    - user: root
    - group: root
    - onchanges:
      - cmd: maven-download-archive

maven-update-home-symlink:
  file.symlink:
    - name: {{ maven.maven_home }}
    - target: {{ maven.maven_real_home }}
    - force: True
    - require:
      - maven-unpack-archive

maven-remove-archive:
  file.absent:
    - name: {{ archive_file }}
    - require:
      - maven-unpack-archive

{%- if maven.source_hash %}
maven-remove-archive-hash:
  file.absent:
    - name: {{ archive_file }}.sha256
    - require:
      - maven-unpack-archive
{%- endif %}

{%- endif %}
