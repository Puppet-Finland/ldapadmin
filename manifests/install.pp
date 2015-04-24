#
# == Class: ldapadmin::install
#
# Installs phpldapadmin package
#
class ldapadmin::install inherits ldapadmin::params {

    package { 'ldapadmin-phpldapadmin':
        ensure  => installed,
        name    => $::ldapadmin::params::package_name,
        require => [ Class['ldapadmin::absent'], Class['php::ldap'] ],
    }
}
