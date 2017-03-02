#
# == Class: ldapadmin::packetfilter
#
# Limits access to phpldapadmin based on IP-address/range
#
class ldapadmin::packetfilter
(
    $port,
    $allow_ipv4_address,
    $allow_ipv6_address
)
{

    # IPv4 rules
    @firewall { '013 ipv4 accept ldapadmin':
        provider => 'iptables',
        chain    => 'INPUT',
        proto    => 'tcp',
        dport    => $port,
        source   => $allow_ipv4_address,
        action   => 'accept',
        tag      => 'default',
    }

    # IPv6 rules
    @firewall { '013 ipv6 accept ldapadmin':
        provider => 'ip6tables',
        chain    => 'INPUT',
        proto    => 'tcp',
        dport    => $port,
        source   => $allow_ipv6_address,
        action   => 'accept',
        tag      => 'default',
    }

}
