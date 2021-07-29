# -*- coding: utf-8 -*-
# vim: ft=yaml
---
maven:
  version: 3.8.1
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
      source_hash: 0ec48eb515d93f8515d4abe465570dfded6fa13a3ceb9aab8031428442d9912ec20f066b2afbf56964ffe1ceb56f80321b50db73cf77a0e2445ad0211fb8e38d
  dir:
    archive: /usr/local/lib
  linux:
    altpriority: 1000
