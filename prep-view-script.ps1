# Usage: prep-view-script.ps1 $(Build.Repository.Name), $(Build.SourceBranch), $(Build.DefinitionName), $(Build.BuildNumber), $(DbName)

Param (
    [string]$Repo,
    [string]$Branch,
    [string]$Pipeline,
    [string]$Build,
    [string]$DbName
)

# Get the directory where the script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$myFinalScript = Join-Path -Path $scriptDir -ChildPath "database\create-views-$($DbName.ToLower()).sql"
Write-Host "Final Script: $($myFinalScript)"

$sourcePath = Join-Path -Path $scriptDir -ChildPath ("database\Views\$($DbName.ToLower())")
Write-Host "Source Path: $sourcePath"

$searchPattern = '*.sql'
$viewList = Get-ChildItem -Path (Join-Path -Path $sourcePath -ChildPath $searchPattern)


# Function to add extended properties for a view
function Add-ExtendedProperties($viewName, $schemaName, $filePath) {
    Write-Host "Processing View: $($schemaName).$($viewName), File: $($filePath)"

    # Add empty line for separation
    Add-Content -Path $filePath -Value ''

    # Add GO to make statement in batch
    Add-Content -Path $filePath -Value 'GO'

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
        Add-Content -Path $filePath -Value "    @level1type = N'VIEW', @level1name = '$viewName';"
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

# Process each view
foreach ($view in $viewList) {
    # Extract view name and schema from the file name
    $viewName = [System.IO.Path]::GetFileNameWithoutExtension($view.Name) 
    $schemaName = "dbo"

    # Check if the file exists and read content into the final script
    if (Test-Path $view.FullName) {
        $viewContent = Get-Content -Path $view.FullName -Encoding UTF8
        $viewContent | Out-File -Append -FilePath $myFinalScript -Encoding UTF8
    } else {
        Write-Host "File does not exist: $($view.FullName)"
    }

    # Process view's extended properties
    Add-ExtendedProperties -viewName $viewName -schemaName $schemaName -filePath $myFinalScript

    # Add a blank line
    Add-Content -Path $myFinalScript -Value ''
}

Exit