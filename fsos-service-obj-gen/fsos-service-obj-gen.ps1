#############################################################
#
# Script: fsos-service-obj-gen.ps1
# Input: ".\fsos-service-obj-input.csv"
# Output: ".\fsos-service-obj-input.csv"
# Description: takes input csv and generates .txt CLI output
#
#
#############################################################
#Make Script location the current folder
Split-Path -parent $MyInvocation.MyCommand.Definition | Set-Location


function Answer-YesNo {
	#Function Returns Boolean output from a yes/no question
	#
	# Usage: Answer-YesNo "Question Text" "Title Text"
	#
	$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes",""
	$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No",""
	$choices = [System.Management.Automation.Host.ChoiceDescription[]]($yes,$no)
	$caption = "Warning!" #Default Caption
	if ($args[1] -ne $null){
		$caption = $args[1]} # Caption Passed as argument
	$message = "Do you want to proceed" #Default Message
	if ($args[0] -ne $null){
		$message = $args[0]} #Message passed as argument
	$result = $Host.UI.PromptForChoice($caption,$message,$choices,0)
	if($result -eq 0) {return $true}
	if($result -eq 1) {return $false}
}
clear
Write-Host -ForegroundColor Red "
#############################################################################
#
#	Fortigate Service Objekt Generator
#
#	Ver. 0.1 / 08.11
#	Author: Samuel Heinrich / info@samuel-heinrich.ch
#
#############################################################################


"

#$VDOMName= ""
$ScriptStart = ""

#$UseVDOMs = Answer-YesNo "Does The Fortigate Configured with VDOMs?" "VDOM Configuration"
#If ($UseVDOMs -eq $True){ 
#	#VDOM Names are Case Sensitive Using the wrong Case could create a new vdom in the CLI
#	$VDOMName = Read-Host "Please Enter VDOM Name (!!Case Sensitive!!):"
#	$ScriptStart = "
#config vdom
#edit $VDOMName"}

$MakeGroup = Answer-YesNo "Wird eine Servicegruppe benötigt?"
$ServiceObjects = Import-Csv .\fsos-service-obj-input.csv
$Script = "
$ScriptStart
config firewall service custom
"
$MemberList = ""
If ($MakeGroup -eq $true)
{
	$GroupName = Read-Host -Prompt "
	Name der Servicegruppe (sg-xxxx) 
	(Vorsicht: keine Leerzeichen)"

	$GroupComment = Read-Host -Prompt "
	Beschreibung der Servicegruppe
	(ex. `"Webex Streaming ports`")"
	$GroupScript = "
	$ScriptStart
config firewall service custom
  edit `"$GroupName`"
  set member"
}

$ServiceObjects | foreach {
#$Addr = $_.Address
$Name = $_.Name.substring(0,1)+$_.Name.substring(1).tolower() 
$tcp = $_.Tcp
$udp = $_.Udp
#$Mask = $_.Mask
$Comment = $_.Comment

$Script += "
edit `"$Name`"
  set comment `"$Comment`"
  set udp-portrange $udp
  set tcp-portrange $tcp
next"

if ($MakeGroup -eq $true){
$MemberList += " `"$Name`""}
}
$Script += "
end"

if ($MakeGroup -eq $true){
$GroupScript += "$MemberList
set comment `"$GroupComment`"
next
end"
}
Write-Host $Script
Write-Host $GroupScript
$Script > .\fsos-service-obj-output.txt
$GroupScript >> .\fsos-service-obj-output.txt

Write-Host -ForegroundColor Green "
#############################################################################
#
#	CLI Output wurde erstellt .\fsos-service-obj-output.txt
#
#############################################################################

"

