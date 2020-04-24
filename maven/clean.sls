# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.kernel|lower in ('linux', 'darwin',) %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import maven with context %}

include:
  - .{{ 'package' if maven.pkg.use_upstream_package else 'archive' }}
  - .config.clean
  - .linuxenv.clean

    {%- else %}

maven-not-available-to-install:
  test.show_notification:
    - text: |
        The maven package is unavailable for {{ salt['grains.get']('finger', grains.os_family) }}

    {%- endif %}
