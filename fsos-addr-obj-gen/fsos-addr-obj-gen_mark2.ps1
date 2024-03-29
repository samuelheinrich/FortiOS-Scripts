clear
Write-Host -ForegroundColor Red "
#############################################################################
#
#   Fortigate Adress Objekt Generator Mark2
#
#   Ver. 0.3 / 25.02.2023
#   Author: Samuel Heinrich / info@samuel-heinrich.ch
#
#############################################################################


"



# Set the path to the CSV file
$csvFilePath = "input.csv"

# Check if the CSV file exists
if (Test-Path $csvFilePath) {
    Write-Output "Lese CSV-Datei ein..."
    Write-Host "`r`n"

    # Read the CSV file
    $addresses = Import-Csv $csvFilePath

#    # Loop through each address in the CSV file and generate the CLI syntax
#    foreach ($address in $addresses) {
#        $color = $address.color -as [int]
#        if ($color -and $color -ge 0 -and $color -le 32) {
#            $colorSyntax = "set color $color"
#        } else {
#            $colorSyntax = "set color 0"
#        }

    # Loop through each address in the CSV file and generate the CLI syntax
    foreach ($address in $addresses) {
        $cliSyntax = "config firewall address `n" +
            "    edit `"$($address.name)`" `n" +
            "        set subnet $($address.subnet) `n" +
            "        set comment `"$($address.comment)`" `n" +
            "        set color `"$($address.color)`" `n" +
            "    next `n" +
            "end"
        # Print the CLI syntax for each address
        Write-Output $cliSyntax
    }

    Write-Host -ForegroundColor Green "OK"
}
else {
    Write-Host -ForegroundColor Red "Datei nicht gefunden"
}