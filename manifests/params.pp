#
# == Class: ldapadmin::params
#
# Defines some variables based on the operating system
#
class ldapadmin::params {

    include ::os::params

    case $::osfamily {
        'RedHat': {
            $package_name = 'phpldapadmin'
            $root_dir = '/usr/share/phpldapadmin'
            $template_dir = "${root_dir}/templates"
            $template_group = 'root'
            $template_mode = 644
        }
        'Debian': {
            $package_name = 'phpldapadmin'
            $root_dir = '/usr/share/phpldapadmin'
            $template_dir = '/etc/phpldapadmin/templates'
            $template_group = 'www-data'
            $template_mode = 640
        }
        default: {
            fail("Unsupported operating system ${::osfamily}")
        }
    }
}
