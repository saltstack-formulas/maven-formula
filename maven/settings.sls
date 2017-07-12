{% set p  = salt['pillar.get']('maven', {}) %}
{% set g  = salt['grains.get']('maven', {}) %}

{%- set maven_home      = salt['grains.get']('maven_home', salt['pillar.get']('maven_home', '/opt/maven' )) %}

{%- set version        = g.get('version', p.get('version', '3.3.9')) %}
{%- set major          = version.split('.') | first %}
{%- set mirror         = g.get('mirror', p.get('mirror', 'http://www.us.apache.org/dist/maven' )) %}

{%- set default_prefix     = '/usr/lib' %}
{%- set default_m2_home    = default_prefix + '/apache-maven-' %}
{%- set default_source_url = mirror + '/maven-' + major + '/' + version + '/binaries/apache-maven-' + version + '-bin.tar.gz' %}
{%- set default_source_hash = default_source_url + '.sha1' %}
{%- set default_dl_opts     = '-s' %}
{%- set default_unpack_opts = 'z' %}
{%- set default_archive_type = 'tar' %}
{%- set default_real_home  = default_prefix + '/apache-maven-' + version %}
{%- set default_symlink    = '/usr/bin/mvn' %}
{%- set default_realcmd    = maven_home + '/bin/mvn' %}

{%- set source_url         = g.get('source_url', p.get('source_url', default_source_url)) %}
{%- if source_url == default_source_url %}
  {%- set source_hash      = default_source_hash %}
{%- else %}
  {%- set source_hash      = g.get('source_hash', p.get('source_hash', default_source_hash )) %}
{%- endif %}

{%- set m2_home            = g.get('m2_home', p.get('m2_home', default_m2_home )) %}
{%- set dl_opts            = g.get('dl_opts', p.get('dl_opts', default_dl_opts)) %}
{%- set prefix             = g.get('prefix', p.get('prefix', default_prefix )) %}
{%- set maven_real_home    = g.get('real_home', p.get('real_home', default_real_home )) %}
{%- set maven_symlink      = g.get('symlink', p.get('symlink', default_symlink )) %}
{%- set maven_realcmd      = g.get('realcmd', p.get('realcmd', default_realcmd )) %}
{%- set unpack_opts        = g.get('unpack_opts', p.get('unpack_opts', default_unpack_opts )) %}
{%- set archive_type       = g.get('archive_type', p.get('archive_type', default_archive_type )) %}

{%- set maven = {} %}
{%- do maven.update( {   'version'      : version,
                         'maven_home'   : maven_home,
                         'source_url'   : source_url,
                         'source_hash'  : source_hash,
                         'prefix'       : prefix,
                         'm2_home'      : m2_home,
                         'dl_opts'      : dl_opts,
                         'unpack_opts'  : unpack_opts,
                         'archive_type' : archive_type,
                         'maven_real_home': maven_real_home,
                         'maven_symlink': maven_symlink,
                         'maven_realcmd': maven_realcmd,
                     }) %}
