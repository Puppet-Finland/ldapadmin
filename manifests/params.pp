#
# == Class: ldapadmin::params
#
# Defines some variables based on the operating system
#
class ldapadmin::params {

    case $::osfamily {
        'RedHat': {
            $package_name = 'phpldapadmin'
            $template_dir = '/usr/share/phpldapadmin/templates'
            $template_group = 'root'
            $template_mode = 644
        }
        'Debian': {
            $package_name = 'phpldapadmin'
            $template_dir = '/etc/phpldapadmin/templates'
            $template_group = 'www-data'
            $template_mode = 640
        }
        default: {
            $package_name = 'phpldapadmin'
            $template_dir = '/etc/phpldapadmin/templates'
            $template_group = 'www-data'
            $template_mode = 640
        }
    }
}