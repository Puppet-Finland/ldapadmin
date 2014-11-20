# == Class: ldapadmin
#
# This class installs phpldapadmin and configures apache2 appropriately. 
# Currently only supports one LDAP server connection. Apache2 module needs to be 
# included separately, as it may require parameters, too.
#
# Currently supports Debian/Ubuntu. Has partial support for RedHat family of 
# operating systems.
#
# == Parameters
#
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
class ldapadmin(
    $ldap_host = $::ldap_host,
    $ldap_port = $::ldap_port,
    $ldap_basedn = $::ldap_basedn,
    $ldap_admin_binddn = $::ldap_admin_binddn,
    $allow_ipv4_address = '127.0.0.1',
    $allow_ipv6_address = '::1'
)
{

# Rationale for this is explained in init.pp of the sshd module
if hiera('manage_ldapadmin', 'true') != 'false' {

    # Dependencies
    include php
    include php::ldap

    include ldapadmin::absent

	include ldapadmin::install

    # The phpldapadmin package in Ubuntu 14.04 (1.2.2-5ubuntu1) is horribly 
    # broken, and we need to patch the sources while the package is being fixed.
    if $::lsbdistcodename == 'trusty' {
        include ldapadmin::install::trusty
    }

    class { 'ldapadmin::config':
        ldap_host => $ldap_host,
        ldap_port => $ldap_port,
        ldap_basedn => $ldap_basedn,
        ldap_admin_binddn => $ldap_admin_binddn,
    }

    # For now only do the Apache2 integration on Debian derivatives
    if $::osfamily == 'Debian' {
    	include ldapadmin::apache2::debian
    }

    if tagged('packetfilter') {
        class { 'ldapadmin::packetfilter':
            allow_ipv4_address => $allow_ipv4_address,
            allow_ipv6_address => $allow_ipv6_address
        }
    }
}
}
