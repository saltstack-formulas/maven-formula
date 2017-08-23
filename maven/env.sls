{%- from 'maven/settings.sls' import maven with context %}

maven-config:
  file.managed:
    - name: /etc/profile.d/apache-maven.sh
    - source: salt://maven/files/apache-maven.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      m2_home: {{ maven.m2_home }}

maven-settings:
  file.managed:
    - name: /home/{{ pillar['user'] }}/.m2/settings.xml
    - source: salt://maven/files/maven-settings.xml
    - template: jinja
    - makedirs: True
    - mode: 644
    - user: {{ pillar['user'] }}
{% if salt['grains.get']('os_family') == 'Suse' or salt['grains.get']('os') == 'SUSE' %}
    - group: users
{% else %}
    - group: {{ pillar['user'] }}
{% endif %}
    - context:
      orgdomain: {{ maven.orgdomain }}
      scmhost: {{ maven.scmhost }}
      repohost: {{ maven.repohost }}

{% if maven.archetypes != 'undefined' %}
maven-archetypes:
  cmd.run:
    - name: curl {{ maven.dl_opts }} -o /home/{{ pillar['user'] }}/.m2/archetype-catalog.xml '{{ maven.archetypes }}'
    - require:
      - file: maven-settings
{% endif %}

# Add maven to alternatives system
maven-home-alt-install:
  alternatives.install:
    - name: maven-home
    - link: {{ maven.maven_home }}
    - path: {{ maven.maven_real_home }}
    - priority: {{ maven.alt_priority }} 

# Set maven alternatives
maven-home-alt-set:
  alternatives.set:
  - name: maven-home
  - path: {{ maven.maven_real_home }}
  - onchanges:
    - alternatives: maven-home-alt-install

maven-alt-install:
  alternatives.install:
    - name: maven
    - link: {{ maven.maven_symlink }}
    - path: {{ maven.maven_realcmd }}
    - priority: {{ maven.alt_priority }}
    - onchanges:
      - alternatives: maven-home-alt-set

maven-alt-set:
  alternatives.set:
  - name: maven
  - path: {{ maven.maven_realcmd }}
  - onchanges:
    - alternatives: maven-alt-install
