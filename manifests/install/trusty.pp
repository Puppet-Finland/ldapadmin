#
# == Class: ldapadmin::install::trusty
#
# Install steps specific to Ubuntu 14.0.4 ("Trusty Tahr")
#
class ldapadmin::install::trusty {

    include ldapadmin::params

    file { 'ldapadmin-php-5.5-compatibility.patch':
        name => "${::ldapadmin::params::root_dir}/php5.5-compatibility.patch",
        content => template('ldapadmin/php5.5-compatibility.patch.erb'),
        owner => root,
        group => root,
        mode => 644,
        require => Class['ldapadmin::install'],
    }

    # Apply the patch, unless the code has been fixed already by this patch or 
    # by an updated phpldapadmin package.
    exec { 'ldapadmin-patch-for-php-5.5':
        command => "patch -p1 < ${::ldapadmin::params::root_dir}/php5.5-compatibility.patch",
        unless => "grep preg_replace_callback ${::ldapadmin::params::root_dir}/lib/functions.php",
        cwd => "${::ldapadmin::params::root_dir}",
        user => root,
        path => [ '/bin', '/usr/bin', '/usr/local/bin' ],
        require => File['ldapadmin-php-5.5-compatibility.patch'],
    }
}
