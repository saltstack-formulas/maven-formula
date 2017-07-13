{%- from 'maven/settings.sls' import maven with context %}

maven-config:
  file.managed:
    - name: /etc/profile.d/apache-maven.sh
<<<<<<< HEAD
    - source: salt://maven/file/apache-maven.sh
=======
    - source: salt://maven/files/apache-maven.sh
>>>>>>> 69b51a61631fd1528b35afe65157086f21fa4620
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
    - priority: 30
    - require:
      - maven-update-home-symlink

maven-alt-install:
  alternatives.install:
    - name: maven
    - link: {{ maven.maven_symlink }}
    - path: {{ maven.maven_realcmd }}
    - priority: 30
    - require:
      - maven-update-home-symlink

# Set maven alternatives
maven-home-alt-set:
  alternatives.set:
  - name: maven-home
  - path: {{ maven.maven_real_home }}
  - require:
    - maven-home-alt-install

maven-alt-set:
  alternatives.set:
  - name: maven
  - path: {{ maven.maven_realcmd }}
  - require:
    - maven-alt-install

# source PATH with JAVA_HOME
maven-source-file:
  cmd.run:
  - name: source /etc/profile
  - cwd: /root
  - require:
    - maven-update-home-symlink

