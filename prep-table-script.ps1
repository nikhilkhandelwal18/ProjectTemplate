# Usage: prep-table-script.ps1 $(Build.Repository.Name), $(Build.SourceBranch), $(Build.DefinitionName), $(Build.BuildNumber), $(DbName)

Param ([string]$Repo, [string]$Branch, [string]$Pipeline, [string]$Build, [string]$DbName, [string]$AppName)

# Get the directory where the script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$myFinalScript = Join-Path -Path $scriptDir -ChildPath "database\create-tables-$($AppName.ToLower()).sql"
Write-Host "Final Script: $($myFinalScript)"

$tableList = Get-Content -Path "database\tables-$($AppName.ToLower()).json" -Raw | ConvertFrom-Json

# Function to add extended properties for a table
function Add-ExtendedProperties($tableName, $schemaName, $filePath) {
    Write-Host "Processing Table: $($schemaName).$($tableName), File: $($filePath)"

    # Add empty line for separation
    Add-Content -Path $filePath -Value ''

    # Define property values
    $properties = @(
        @{"name"="GitHub Repo"; "value"=$Repo},
        @{"name"="Branch Name"; "value"=$Branch},
        @{"name"="Pipeline Name"; "value"=$Pipeline},
        @{"name"="Build Number"; "value"=$Build}
    )

    # Loop through properties and write to file
    foreach ($prop in $properties) {
        Add-Content -Path $filePath -Value "-- Add Extended Properties - $($prop.name)"
        Add-Content -Path $filePath -Value "EXEC sys.sp_addextendedproperty @name = N'$($prop.name)',"
        Add-Content -Path $filePath -Value "    @value = N'$($prop.value)',"
        Add-Content -Path $filePath -Value "    @level0type = N'SCHEMA', @level0name = '$schemaName',"
        Add-Content -Path $filePath -Value "    @level1type = N'Table', @level1name = '$tableName';"
        Add-Content -Path $filePath -Value "GO"
        Add-Content -Path $filePath -Value ''
    }
}

# Create or clear the final script before appending
if (Test-Path $myFinalScript) {
    Clear-Content -Path $myFinalScript
} else {
    New-Item -Path $myFinalScript -ItemType File
}

# Add the USE statement at the top of the SQL file
Add-Content -Path $myFinalScript -Value "USE [$DbName]"
Add-Content -Path $myFinalScript -Value "GO"
Add-Content -Path $myFinalScript -Value ''

# Process each parent table and its children
foreach ($table in $tableList.Tables) {
    $parentTable = $table.tableName
    $schemaName = $table.schemaName
    $myFile = Join-Path -Path $scriptDir -ChildPath $table.fileName

    # Check if the file exists and read content into the final script
    if (Test-Path $myFile) {
        $myTableContent = Get-Content -Path $myFile -Encoding UTF8
        $myTableContent | Out-File -Append -FilePath $myFinalScript -Encoding UTF8
    } else {
        Write-Host "File does not exist: $myFile"
    }

    # Process parent table's extended properties
    Add-ExtendedProperties -tableName $parentTable -schemaName $schemaName -filePath $myFinalScript

    # Process child tables' extended properties
    foreach ($childTable in $table.children) {
        Add-ExtendedProperties -tableName $childTable -schemaName $schemaName -filePath $myFinalScript

        #Start-Sleep -Seconds 2
    }

    # Add a blank line
    Add-Content -Path $myFinalScript -Value ''
}

Exit
