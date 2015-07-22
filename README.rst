=============
maven-formula
=============

No maven package is currently available for CentOS, installing maven on a minimal Fedora 20 system will add no less than
152 dependencies! This formula pulls the official Apache Maven tarball and installs it. There are no dependencies even
though you will need a JVM installed to run maven in the end.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``maven``
---------

Downloads the tarball from **maven:source_url** and unpacks it. It will also configure an alternatives path.
The current default is **maven:version** of 3.3.3

``maven.env``
-------------

Adds /etc/profile.d/mvn.sh, this will add M2_HOME and the mvn M2_HOME/bin to the PATH of any user.

Please see the pillar.example for configuration.

