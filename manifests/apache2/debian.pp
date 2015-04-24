#
# == Class ldapadmin::apache2::debian
#
# Integrates phpldapadmin with apache2 on Debian derivatives
#
class ldapadmin::apache2::debian
(
    $port

) inherits ldapadmin::params
{

    file { 'ldapadmin-ldapadmin-vhost.conf':
        ensure  => present,
        name    => '/etc/apache2/sites-available/ldapadmin-vhost.conf',
        content => template('ldapadmin/ldapadmin-vhost.conf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['ldapadmin::config'],
        notify  => Class['apache2::service'],
    }

    # This is the puppet way of creating links; here we enable the ldapadmin
    # VirtualHost. This will only work on Debian/Ubuntu derivatives
    file { 'ldapadmin-500-ldapadmin-vhost.conf':
        ensure  => symlink,
        name    => '/etc/apache2/sites-enabled/500-ldapadmin-vhost.conf',
        target  => '/etc/apache2/sites-available/ldapadmin-vhost.conf',
        require => File['ldapadmin-ldapadmin-vhost.conf'],
        notify  => Class['apache2::service'],
    }
}
