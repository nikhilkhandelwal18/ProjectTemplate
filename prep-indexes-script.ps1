# Usage: prep-indexes-script.ps1
Param ([string]$DbName)

# Get the directory where the script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$outputFile = Join-Path -Path $scriptDir -ChildPath "database\create-indexes-$($DbName.ToLower()).sql"
Write-Host "Final Script: $($outputFile)"

$sourceFolder = Join-Path -Path $scriptDir -ChildPath "database\Indexes\$($DbName.ToLower())"
Write-Host "Source Script: $($sourceFolder)"

# Get all .sql files from the folder
$sqlFiles = Get-ChildItem -Path $sourceFolder -Filter "*.sql" | Sort-Object Name

# Ensure output file is empty before writing
Set-Content -Path $outputFile -Value "-- Merged SQL Scripts`r`n"

# Add the USE statement at the top of the SQL file
Add-Content -Path $outputFile -Value "USE [$DbName]"
Add-Content -Path $outputFile -Value "GO"
Add-Content -Path $outputFile -Value ''


foreach ($file in $sqlFiles) {
   # Check if the file name is the one to ignore
    if ($file.Name -eq "060_033_IDX_CNJT_EMP_FL.sql") {
        Write-Host "Ignoring file: $($file.Name)"
        continue  # Skip this file
    }

    "-- File: $($file.Name)" | Add-Content -Path $outputFile
    Get-Content -Path $file.FullName | Add-Content -Path $outputFile
    "`r`n GO `r`n" | Add-Content -Path $outputFile  # Add a newline for readability
}

Write-Host "SQL files merged into $outputFile"


Exit
