# -*- coding: utf-8 -*-
# vim: ft=yaml
---
maven:
  version: 3.8.0
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
      source_hash: sha1=62a783cbf1b4fb9664f9accf7a16ae2488dcb61c
  dir:
    archive: /usr/local/lib
  linux:
    altpriority: 1000
