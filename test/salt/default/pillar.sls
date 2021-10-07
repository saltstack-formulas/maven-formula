# -*- coding: utf-8 -*-
# vim: ft=yaml
---
maven:
  version: 3.8.3
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
    uri: http://www.apache.org/dist/maven
    archive:
      # yamllint disable-line rule:line-length
      source_hash: 1c12a5df43421795054874fd54bb8b37d242949133b5bf6052a063a13a93f13a20e6e9dae2b3d85b9c7034ec977bbc2b6e7f66832182b9c863711d78bfe60faa
  dir:
    archive: /usr/local/lib
  linux:
    altpriority: 1000
