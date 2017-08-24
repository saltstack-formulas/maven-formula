{%- from 'maven/settings.sls' import maven with context %}

{%- for mavenuser in maven.users %}
maven-settings-{{ mavenuser }}:
  file.managed:
    - name: /home/{{ mavenuser }}/.m2/settings.xml
    - source: salt://maven/files/maven-settings.xml
    - template: jinja
    - makedirs: True
    - mode: 644
    - user: {{ mavenuser }}
{% if salt['grains.get']('os_family') == 'Suse' or salt['grains.get']('os') == 'SUSE' %}
    - group: users
{% else %}
    - group: {{ mavenuser }}
{% endif %}
    - context:
      orgdomain: {{ maven.orgdomain }}
      scmhost: {{ maven.scmhost }}
      repohost: {{ maven.repohost }}

{% if maven.archetypes != 'undefined' %}
maven-archetypes-{{ mavenuser }}:
  cmd.run:
    - name: curl {{ maven.dl_opts }} -o /home/{{ mavenuser }}/.m2/archetype-catalog.xml '{{ maven.archetypes }}'
    - require:
      - file: maven-settings
{% endif %}
{% endfor %}

