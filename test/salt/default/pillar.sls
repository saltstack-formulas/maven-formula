# -*- coding: utf-8 -*-
# vim: ft=yaml
---
maven:
  version: 3.3.9
  release: maven-3

  config_file: .m2/settings.xml
  config:
    orgdomain: example.com
    scmhost: scmhost
    repohost: repository
  archetypes_file: .m2/archetype-catalog.xml
  archetypes_url: None
  identity:
    user: root
  pkg:
    use_upstream_archive: true
    use_upstream_package: false
    uri: http://www.us.apache.org/dist/maven
    archive:
      source_hash: sha1=5b4c117854921b527ab6190615f9435da730ba05
  dir:
    archive: /usr/local/lib
  linux:
    altpriority: 1000
