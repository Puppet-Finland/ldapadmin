#
# == Class ldapadmin::absent
#
# Remove various obsolete configurations
#
class ldapadmin::absent {

    file { 'ldapadmin-ldapadmin-vhost':
        name => '/etc/apache2/sites-available/ldapadmin-vhost',
        ensure => absent,
        notify => Class['apache2::service'],
    }

    file { 'ldapadmin-500-ldapadmin-vhost':
        name => '/etc/apache2/sites-enabled/500-ldapadmin-vhost',
        ensure => 'absent',
        notify => Class['apache2::service'],
    }
}
