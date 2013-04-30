#
# == Class: ldapadmin::params
#
# Defines some variables based on the operating system
#
class ldapadmin::params {

    case $::osfamily {
        'RedHat': {
            $package_name = 'phpldapadmin'
        }
        'Debian': {
            $package_name = 'phpldapadmin'
        }
        default: {
            $package_name = 'phpldapadmin'
        }
    }
}
