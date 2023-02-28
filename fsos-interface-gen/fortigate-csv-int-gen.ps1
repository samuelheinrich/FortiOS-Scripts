#############################################################################
#
#	FORTIGATE 7.x Interface Rule Bulk GENERATOR
#
#	Ver. 0.1 / 07.11.2022
#	Author: Samuel Heinrich / info@samuel-heinrich.ch
#
#
#############################################################################

$interfaces = Import-Csv ./fsos-interface-input.csv

Foreach ($interface in $interfaces) {
echo "config system interface"
    echo ("edit "+ $interface.vlanname)
        echo ("set vdom " + $interface.vdom)
        echo ("set ip " + $interface.ip)
        echo ("set allowaccess " + $interface.allowaccess)
        echo ("set description " + $interface.description)
        echo ("set alias " + $interface.alias)
        echo "set device-identification enable"
        echo ("set role " + $interface.role)
        echo ("set interface " + $interface.interface)
        echo ("set vlanid " + $interface.vlanid)
        echo ("set status " + $interface.status)
    echo "next"
echo "end"
}
