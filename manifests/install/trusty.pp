#
# == Class: ldapadmin::install::trusty
#
# Install steps specific to Ubuntu 14.0.4 ("Trusty Tahr")
#
class ldapadmin::install::trusty {

    include ::ldapadmin::params

    file { 'ldapadmin-TemplateRender.php.patch':
        name    => "${::ldapadmin::params::root_dir}/TemplateRender.php.patch",
        content => template('ldapadmin/TemplateRender.php.patch.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['ldapadmin::install'],
    }

    # Apply the patch, unless the code has been fixed already by this patch or 
    # by an updated phpldapadmin package.
    exec { 'ldapadmin-patch-TemplateRender.php':
        command => "patch -p0 < ${::ldapadmin::params::root_dir}/TemplateRender.php.patch",
        unless  => "grep password_hash_custom ${::ldapadmin::params::root_dir}/lib/TemplateRender.php",
        cwd     => "${::ldapadmin::params::root_dir}/lib",
        user    => $::os::params::adminuser,
        path    => [ '/bin', '/usr/bin', '/usr/local/bin' ],
        require => File['ldapadmin-TemplateRender.php.patch'],
    }
}
