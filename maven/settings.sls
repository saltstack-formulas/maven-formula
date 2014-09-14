{% set p  = salt['pillar.get']('maven', {}) %}
{% set g  = salt['grains.get']('maven', {}) %}

{%- set version        = g.get('version', p.get('version', '3.2.2')) %}
{%- set major          = version.split('.') | first %}
{%- set version_name   = 'apache-maven-' + version %}

{%- set default_source_url = 'http://www.us.apache.org/dist/maven/maven-' + major + '/' + version + '/binaries/' + version_name + '-bin.tar.gz' %}
{%- set source_url     = g.get('source_url', p.get('source_url', default_source_url)) %}
{%- set m2_home        = g.get('m2_home', p.get('m2_home', '/usr/lib/apache-maven')) %}
{%- set prefix         = g.get('prefix', p.get('prefix', '/usr/lib')) %}
{%- set real_home      = prefix + '/' + version_name %}

{%- set maven = {} %}

{%- do maven.update( {   'java_home'     : salt['pillar.get']('java_home', '/usr/lib/java'),
                          'version'      : version,
                          'version_name' : version_name,
                          'source_url'   : source_url,
                          'major'        : major,
                          'prefix'       : prefix,
                          'm2_home'      : m2_home,
                          'real_home'    : real_home,
                     }) %}
