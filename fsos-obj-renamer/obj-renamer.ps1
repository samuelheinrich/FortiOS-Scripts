# Lesen Sie das Input-File ein
$input = Get-Content "input.txt"

# Iterieren Sie über jede Zeile des Input-Files
foreach ($line in $input) {
  # Verwenden Sie einen regulären Ausdruck, um IP-Adressen im Format "xxx.xxx.xxx.xxx xxx.xxx.xxx.xxx" zu finden
  if ($line -match "^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}) (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$") {
  # Berechnen Sie die CIDR-Notation für den Bereich von IP-Adressen
$cidr = (New-Object System.Net.IPAddress($matches[1])).IPAddressToString + "/" + (32 - [int] ([math]::Log([int][math]::Pow(2, (32 - [int][System.Net.IPAddress]::Parse($matches[2]).GetAddressBytes()[3])))))).ToString("##")

    # Ersetzen Sie die IP-Adressen im Format "xxx.xxx.xxx.xxx xxx.xxx.xxx.xxx" durch die CIDR-Notation
    $line = $line -replace $matches[0], $cidr
  }
  
  # Geben Sie die aktualisierte Zeile aus
  Write-Output $line
}
