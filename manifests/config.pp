#
# == Class: ldapadmin::config
#
# Configures phpldapadmin
#
class ldapadmin::config(
    ldap_host,
    ldap_port,
    ldap_basedn,
    ldap_admin_binddn
)
{

    include apache2::params

    # Disable VirtualHost definition included in the rpm/deb packages or it will 
    # get on our way.
    file { 'ldapadmin-phpldapadmin':
        name => "${apache2::params::config_dir}/conf.d/phpldapadmin",
        ensure => absent,
        require => Class['ldapadmin::install'],
    }

    file { 'ldapadmin-config.php':
        name => '/etc/phpldapadmin/config.php',
        content => template('ldapadmin/config.php.erb'),
        ensure => present,
        owner => root,
        group => $apache2::params::www_group,
        mode => 640,
        require => Class['ldapadmin::install'],
    }
}
