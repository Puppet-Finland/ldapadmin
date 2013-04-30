#
# == Class ldapadmin::apache2::debian
#
# Integrates phpldapadmin with apache2 on Debian derivatives
#
class ldapadmin::apache2::debian {

    file { 'ldapadmin-ldapadmin-vhost':
        name => '/etc/apache2/sites-available/ldapadmin-vhost',
        content => template('ldapadmin/ldapadmin-vhost.erb'),
        ensure => present,
        owner => root,
        group => root,
        mode => 644,
        require => Class['ldapadmin::config'],
        notify => Class['apache2::service'],
    }

    # This is the puppet way of creating links; here we enable the ldapadmin
    # VirtualHost. This will only work on Debian/Ubuntu derivatives
    file { 'ldapadmin-500-ldapadmin-vhost':
        name => '/etc/apache2/sites-enabled/500-ldapadmin-vhost',
        ensure => '/etc/apache2/sites-available/ldapadmin-vhost',
        require => File['ldapadmin-ldapadmin-vhost'],
        notify => Class['apache2::service'],
    }
}
