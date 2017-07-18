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

Downloads the tarball from **maven:source_url** and unpacks **maven:version** is 3.3.9.

``maven.env``
-------------

Adds /etc/profile.d/apache-maven.sh, setting M2_HOME and M2_HOME/bin to the PATH of any user.

Please see the pillar.example for configuration.

Tested on RedHat/CentOS 5.X or RedHat/CentOS 6.X, AmazonOS, Ubuntu, and Fedora.
