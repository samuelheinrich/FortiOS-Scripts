#############################################################################
#
#	FORTIGATE 7.x FW Rule Bulk GENERATOR
#
#	Ver. 0.2 / 27.10.2022
#	Author: Samuel Heinrich / info@samuel-heinrich.ch
#
#############################################################################

$rules = Import-Csv ./fortigate-csv-fwrule-input.csv

Foreach ($rule in $rules) {
echo "config firewall policy"
    echo "edit 0"
        echo ("set status " + $rule.status)
        echo ("set name " + $rule.name)
        echo ("set srcintf " + $rule.srcintf)
        echo ("set dstintf " + $rule.dstintf)
        echo ("set action " + $rule.action)
        echo ("set srcaddr " + $rule.srcaddr)
        echo ("set dstaddr " + $rule.dstaddr)
        echo ("set schedule " + $rule.schedule)
        echo ("set service " + $rule.service)
        echo ("set nat " + $rule.nat)
       echo ("set comments """ + $rule.comments)
       echo ("set gobal-label " + $rule.label)
#        echo ("set comments " + `$rule.comments")
    echo "next"
echo "end"
}
