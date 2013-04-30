#
# == Class: ldapadmin::packetfilter
#
# Limits access to phpldapadmin based on IP-address/range
#
class ldapadmin::packetfilter(
    $allow_ipv4_address,
    $allow_ipv6_address
)
{

    # IPv4 rules
    firewall { "013 ipv4 accept port 8081 from $allow_ipv4_address":
        provider => 'iptables',
        chain => 'INPUT',
        proto => 'tcp',
        port => 8081,
        source => "$allow_ipv4_address",
        action => 'accept',
    }

    # IPv6 rules
    firewall { "013 ipv6 accept port 8081 from $allow_ipv6_address":
        provider => 'ip6tables',
        chain => 'INPUT',
        proto => 'tcp',
        port => 8081,
        source => "$allow_ipv6_address",
        action => 'accept',
    }

}
