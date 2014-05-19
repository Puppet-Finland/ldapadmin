#
# == Class: ldapadmin::install
#
# Installs phpldapadmin package
#
class ldapadmin::install {

    include ldapadmin::params

    package { 'ldapadmin-phpldapadmin':
        name => $ldapadmin::params::package_name,
        ensure => installed,
        require => [ Class['ldapadmin::absent'], Class['php::ldap'] ],
    }
}
