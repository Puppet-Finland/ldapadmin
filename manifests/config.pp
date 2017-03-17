#
# == Class: ldapadmin::config
#
# Configures phpldapadmin
#
class ldapadmin::config
(
    String  $ldap_host,
    Integer $ldap_port,
    String  $ldap_basedn,
    String  $ldap_admin_binddn
)
{

    include ::apache2::params

    # Disable VirtualHost definition included in the rpm/deb packages or it will 
    # get on our way.
    file { 'ldapadmin-phpldapadmin':
        ensure  => absent,
        name    => "${::apache2::params::conf_d_dir}/phpldapadmin",
        require => Class['ldapadmin::install'],
    }

    file { 'ldapadmin-config.php':
        ensure  => present,
        name    => '/etc/phpldapadmin/config.php',
        content => template('ldapadmin/config.php.erb'),
        owner   => $::os::params::adminuser,
        group   => $::apache2::params::www_group,
        mode    => '0640',
        require => Class['ldapadmin::install'],
    }
}
