#
# == Class ldapadmin::absent
#
# Remove various obsolete configurations
#
class ldapadmin::absent {

    include ldapadmin::params

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

    # Remove the Puppet-managed php5.5-compatibility patch if it exists.
    file { 'ldapadmin-php-5.5-compatibility.patch':
        name => "${::ldapadmin::params::root_dir}/php5.5-compatibility.patch",
        ensure => absent,
    }
}
