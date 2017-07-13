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
  - require:
    - maven-home-alt-install

maven-alt-install:
  alternatives.install:
    - name: maven
    - link: {{ maven.maven_symlink }}
    - path: {{ maven.maven_realcmd }}
    - priority: {{ maven.alt_priority }}
    - require:
      - maven-home-alt-set

maven-alt-set:
  alternatives.set:
  - name: maven
  - path: {{ maven.maven_realcmd }}
  - require:
    - maven-alt-install
