#
# == Define: ldapadmin::template
#
# Install a phpldapadmin template from the Puppet fileserver. Template files are 
# currently not included in the ldapadmin module as they may be highly 
# site-specific.
#
# == Parameters
#
# [*filename*]
#   Name of the file on Puppet files directory (typically /etc/puppet/files)
# [*type*]
#   Template type, either "creation" or "modification". Will determine which 
#   template directory the file goes into.
#
# == Examples
#
#   ldapadmin::template { 'custom inetOrgPerson creation template':
#       filename => 'custom_create_inetOrgPerson.xml',
#       type => 'creation',
#   }
#
# == Authors
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
define ldapadmin::template
(
    String $filename,
    Enum['creation','modification'] $type
)
{

    include ::ldapadmin::params

    file { "ldapadmin-template-${type}-${filename}":
        ensure  => present,
        name    => "${::ldapadmin::params::template_dir}/${type}/${filename}",
        source  => "puppet:///files/${filename}",
        owner   => $::os::params::adminuser,
        group   => $::ldapadmin::params::template_group,
        mode    => $::ldapadmin::params::template_mode,
        require => Class['ldapadmin::install'],
    }

}
