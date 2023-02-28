$inputFile = "input.txt"
$outputFile = "output.txt"

# Lese den Inhalt des Eingabedatei ein
$fileContent = Get-Content $inputFile

# Initialisiere eine Variable, die angibt, ob eine Zeile mit "set comment" vorhanden ist
$commentLineExists = $false

# Durchlaufe jede Zeile des Eingabedateiinhalts
foreach ($line in $fileContent) {
    # Prüfe, ob die Zeile mit "edit" beginnt
    if ($line.StartsWith("edit")) {
        # Extrahiere den Wert hinter "edit"
        $editValue = $line -replace '^edit "(.*)"$', '$1'
    }
    # Prüfe, ob die Zeile mit "set comment" beginnt
    elseif ($line -match '^set comment') {
        # Setze $commentLineExists auf wahr
        $commentLineExists = $true

        # Extrahiere den Text zwischen den ""
        $currentComment = $line -replace '^set comment "(.*)"$', '$1'

        # Erweitere den Text mit dem Wert hinter "edit"
        $newComment = $currentComment + " " + $editValue

        # Erstelle eine neue Zeile mit dem erweiterten Text
        $newLine = "set comment `"$newComment`""
    }
    # Prüfe, ob die Zeile mit "set uuid", "set associated-interface" oder "set subnet" beginnt
    elseif ($line.Trim().StartsWith("set uuid") -or $line.Trim().StartsWith("set associated-interface") -or $line.Trim().StartsWith("set subnet")) {
        # überspringe diese Zeile
        continue
    }
    # Falls keine dieser Bedingungen zutrifft, verwende die aktuelle Zeile unverändert
    else {
        $newLine = $line
    }

    # Schreibe die neue Zeile in die Ausgabedatei
    Add-Content $outputFile $newLine
}

# Falls keine Zeile mit "set comment" vorhanden war
if (!$commentLineExists) {
    # Erstelle eine neue Zeile mit dem Wert hinter "edit"
    $newLine = "set comment `"$editValue`""

    # Schreibe die neue Zeile in die Ausgabedatei
    Add-Content $outputFile $newLine
}
