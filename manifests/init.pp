# == Class: ldapadmin
#
# This class installs phpldapadmin and configures apache2 appropriately. 
# Currently only supports one LDAP server connection. Apache2 module needs to be 
# included separately, as it may require parameters, too.
#
# Currently this module supports Debian/Ubuntu. It also has partial support for 
# RedHat family of operating systems.
#
# == Parameters
#
# [*manage*]
#   Whether to manage phpldapadmin with Puppet or not. Valid values are 'yes' 
#   (default) and 'no'.
# [*port*]
#   The port on which phpldapadmin listens for requests. Defaults to 8081.
# [*ldap_host*]
#   Hostname/IP of the LDAP server. Defaults to $::ldap_host.
# [*ldap_port*]
#   Port used by the LDAP server. Defaults to $::ldap_port.
# [*ldap_basedn*]
#   Root/base dn. Defaults to $::ldap_basedn.
# [*ldap_admin_binddn*]
#   Administrative account's dn. Defaults to $::ldap_admin_binddn.
# [*allow_ipv4_address*]
#   IPv4 address/subnet from which to allow connections. Defaults to 127.0.0.1.
# [*allow_ipv6_address*]
#   IPv6 address/subnet from which to allow connections. Defaults to ::1.
# [*templates*]
#   A hash of ldapadmin::template resources to realize.
#
# == Examples
#
#   class {'ldapadmin':
#       ldap_host => 'ldap.domain.com',
#       ldap_port => 389,
#       ldap_basedn => 'dc=domain,dc=com',
#       ldap_admin_binddn => 'cn=admin,dc=domain,dc=com',
#       allow_ipv4_address => '192.168.0.0/24',
#       allow_ipv6_address => '::1',
#   }
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class ldapadmin
(
    $manage = 'yes',
    $port = 8081,
    $ldap_host = $::ldap_host,
    $ldap_port = $::ldap_port,
    $ldap_basedn = $::ldap_basedn,
    $ldap_admin_binddn = $::ldap_admin_binddn,
    $allow_ipv4_address = '127.0.0.1',
    $allow_ipv6_address = '::1',
    $templates = {}
)
{

if $manage == 'yes' {

    # Dependencies
    include ::php
    include ::php::ldap

    include ::ldapadmin::absent

    include ::ldapadmin::install

    # The phpldapadmin package in Ubuntu 14.04 (1.2.2-5ubuntu1) is horribly 
    # broken, and we need to patch the sources while the package is being fixed.
    if $::lsbdistcodename == 'trusty' {
        include ::ldapadmin::install::trusty
    }

    # Add custom phpldapadmin create/modify templates
    create_resources('ldapadmin::template', $templates)

    class { '::ldapadmin::config':
        ldap_host         => $ldap_host,
        ldap_port         => $ldap_port,
        ldap_basedn       => $ldap_basedn,
        ldap_admin_binddn => $ldap_admin_binddn,
    }

    # For now only do the Apache2 integration on Debian derivatives
    if $::osfamily == 'Debian' {
        class { '::ldapadmin::apache2::debian':
            port => $port,
        }
    }

    if tagged('packetfilter') {
        class { '::ldapadmin::packetfilter':
            port               => $port,
            allow_ipv4_address => $allow_ipv4_address,
            allow_ipv6_address => $allow_ipv6_address
        }
    }
}
}
