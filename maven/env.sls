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

### Primary user environment support ##
{% if maven.user != 'undefined_user' %}

maven-settings:
  file.managed:
    - name: /home/{{ maven.user }}/.m2/settings.xml
    - source: salt://maven/files/maven-settings.xml
    - template: jinja
    - makedirs: True
    - mode: 644
    - user: {{ maven.user }}
  {% if salt['grains.get']('os_family') == 'Suse' or salt['grains.get']('os') == 'SUSE' %}
    - group: users
  {% else %}
    - group: {{ maven.user }}
  {% endif %}
    - context:
      orgdomain: {{ maven.orgdomain }}
      scmhost: {{ maven.scmhost }}
      repohost: {{ maven.repohost }}

  {% if maven.archetypes != 'undefined' %}
maven-archetypes:
  cmd.run:
    - name: curl {{ maven.dl_opts }} -o /home/{{ maven.user }}/.m2/archetype-catalog.xml '{{ maven.archetypes }}'
    - require:
      - file: maven-settings
    {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ maven.dl_retries }}
        interval: 60
        splay: 10
    {% endif %}
  file.managed:
    - name: /home/{{ maven.user }}/.m2/archetype-catalog.xml
    - replace: False
    - mode: 644
    - user: {{ maven.user }}
     {% if salt['grains.get']('os_family') == 'Suse' or salt['grains.get']('os') == 'SUSE' %}
    - group: users
     {% else %}
    - group: {{ maven.user }}
     {% endif %}
  {% endif %}

{% endif %}

# Add maven to alternatives system
maven-home-alt-install:
  alternatives.install:
    - name: maven-home
    - link: {{ maven.maven_home }}
    - path: {{ maven.real_home }}
    - priority: {{ maven.alt_priority }} 

# Set maven alternatives
maven-home-alt-set:
  alternatives.set:
  - name: maven-home
  - path: {{ maven.real_home }}
  - require:
    - alternatives: maven-home-alt-install
  - onchanges:
    - alternatives: maven-home-alt-install

maven-alt-install:
  alternatives.install:
    - name: maven
    - link: {{ maven.symlink }}
    - path: {{ maven.realcmd }}
    - priority: {{ maven.alt_priority }}
    - require:
      - alternatives: maven-home-alt-set
    - onchanges:
      - alternatives: maven-home-alt-install
      - alternatives: maven-home-alt-set

maven-alt-set:
  alternatives.set:
  - name: maven
  - path: {{ maven.realcmd }}
  - require:
    - alternatives: maven-alt-install
  - onchanges:
    - alternatives: maven-alt-install
