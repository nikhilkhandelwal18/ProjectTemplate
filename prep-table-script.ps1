#usage prep-table-script.ps1 $(Build.Repository.Name), $(Build.SourceBranch), $(Build.DefinitionName), $(Build.BuildNumber)


Param ($Repo, $Branch, $Pipeline, $Build)

# Getting a list of all Table creation files
$Files = Get-ChildItem -Path 'database\Tables\*.sql' 
foreach ($File in $Files)
{
  #Add Extended Properties to the SP script - Build Info
  Add-Content -Path $File -Value ''

 $Value = "--Add Extended Properties - GitHub Repo"
  Add-Content -Path $File -Value $Value

  $Value = "EXEC sys.sp_addextendedproperty @name = N'GitHub Repo',"
  Add-Content -Path $File -Value $Value

  $Value = "    @value = N'" + $Repo +"',"
  Add-Content -Path $File -Value $Value

  $Value = "    @level0type = N'SCHEMA', @level0name = 'dbo',"
  Add-Content -Path $File -Value $Value

  $Value = "    @level1type = N'Table', @level1name = '" + $File.BaseName + "';"
  Add-Content -Path $File -Value $Value

  $Value = "GO"
  Add-Content -Path $File -Value $Value

  Add-Content -Path $File -Value ''

  $Value = "--Add Extended Properties - Branch Name"
  Add-Content -Path $File -Value $Value

  $Value = "EXEC sys.sp_addextendedproperty @name = N'Branch Name',"
  Add-Content -Path $File -Value $Value

  $Value = "    @value = N'" + $Branch +"',"
  Add-Content -Path $File -Value $Value

  $Value = "    @level0type = N'SCHEMA', @level0name = 'dbo',"
  Add-Content -Path $File -Value $Value

  $Value = "    @level1type = N'Table', @level1name = '" + $File.BaseName + "';"
  Add-Content -Path $File -Value $Value

  $Value = "GO"
  Add-Content -Path $File -Value $Value

  Add-Content -Path $File -Value ''

  $Value = "--Add Extended Properties - Pipeline Name"
  Add-Content -Path $File -Value $Value

  $Value = "EXEC sys.sp_addextendedproperty @name = N'Pipeline Name',"
  Add-Content -Path $File -Value $Value

  $Value = "    @value = N'" + $Pipeline +"',"
  Add-Content -Path $File -Value $Value

  $Value = "    @level0type = N'SCHEMA', @level0name = 'dbo',"
  Add-Content -Path $File -Value $Value

  $Value = "    @level1type = N'Table', @level1name = '" + $File.BaseName + "';"
  Add-Content -Path $File -Value $Value

  $Value = "GO"
  Add-Content -Path $File -Value $Value

  Add-Content -Path $File -Value ''

  $Value = "--Add Extended Properties - Build Number"
  Add-Content -Path $File -Value $Value

  $Value = "EXEC sys.sp_addextendedproperty @name = N'Build Number',"
  Add-Content -Path $File -Value $Value

  $Value = "    @value = N'" + $Build +"',"
  Add-Content -Path $File -Value $Value

  $Value = "    @level0type = N'SCHEMA', @level0name = 'dbo',"
  Add-Content -Path $File -Value $Value

  $Value = "    @level1type = N'Table', @level1name = '" + $File.BaseName + "';"
  Add-Content -Path $File -Value $Value

  $Value = "GO"
  Add-Content -Path $File -Value $Value

  Add-Content -Path $File -Value ''
}