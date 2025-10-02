#usage .\prep-sp-script.ps1 $(Build.Repository.Name), $(Build.SourceBranch), $(Build.DefinitionName), $(Build.BuildNumber)

Param ($Repo, $Branch, $Pipeline, $Build)

$PS1File = '.\database\Stored Procedures\create-sp.ps1'
New-Item -Path $PS1File -ItemType File -Force | Out-Null

$Value = '# Dev Usage:  .\create-sp.ps1 -ServerName ''AWSVAMFRRDS01D.njt.gov'' -DBName ''BVMS'''
Add-Content -Path $PS1File -Value $Value

$Value = '# Test Usage: .\create-sp.ps1 -ServerName ''AWSVAMFRRDS01T.njt.gov'' -DBName ''BVMS'''
Add-Content -Path $PS1File -Value $Value

$Value = '# Prod Usage: .\create-sp.ps1 -ServerName ''AWSVAMFRRDS01P.njt.gov'' -DBName ''BVMS'''
Add-Content -Path $PS1File -Value $Value

$Value = 'Param ($ServerName, $DBName)'
Add-Content -Path $PS1File -Value $Value
Add-Content -Path $PS1File -Value ''

$Value = '# Run the SP creation scripts using ConnectionString: -ConnectionString "Data Source=$ServerName; Initial Catalog=$DBName; Integrated Security=True; TrustServerCertificate=true;"'
Add-Content -Path $PS1File -Value $Value

#Invoke-Sqlcmd -InputFile "MyScript.sql" -ConnectionString "Data Source=MYSERVER;Initial Catalog=MyDatabase;Integrated Security=True;ApplicationIntent=ReadOnly"
$ConnectionString = '"Data Source=$ServerName; Initial Catalog=$DBName; Integrated Security=True; TrustServerCertificate=true;"'

# Getting a list of all Stored Procedure files
$Files = Get-ChildItem -Path 'database\Stored Procedures\*.sql'
foreach ($File in $Files)
{
  $FileName = $File.Name
  $Value = "Invoke-Sqlcmd -InputFile ""$FileName"" -ConnectionString $ConnectionString"
  Add-Content -Path $PS1File -Value $Value

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

  $Value = "    @level1type = N'Procedure', @level1name = '" + $File.BaseName + "';"
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

  $Value = "    @level1type = N'Procedure', @level1name = '" + $File.BaseName + "';"
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

  $Value = "    @level1type = N'Procedure', @level1name = '" + $File.BaseName + "';"
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

  $Value = "    @level1type = N'Procedure', @level1name = '" + $File.BaseName + "';"
  Add-Content -Path $File -Value $Value

  $Value = "GO"
  Add-Content -Path $File -Value $Value

  Add-Content -Path $File -Value ''
}

# Getting a list of all function files
$SearchPattern = 'abx_*.sql'
$Files = Get-ChildItem -Path 'database\Functions\abx_*.sql'
foreach ($File in $Files)
{
  $FileName = $File.Name
  $FunctionName =  $File.BaseName -replace '^abx_', ''
  $Value = "Invoke-Sqlcmd -InputFile ""$FileName"" -ConnectionString $ConnectionString"
  Add-Content -Path $PS1File -Value $Value

  #Add Extended Properties to the SP script - Build Info
  Add-Content -Path $File -Value ''

 $Value = "--Add Extended Properties - GitHub Repo"
  Add-Content -Path $File -Value $Value

  $Value = "EXEC sys.sp_addextendedproperty @name = N'GitHub Repo',"
  Add-Content -Path $File -Value $Value

  $Value = "    @value = N'" + $Repo +"',"
  Add-Content -Path $File -Value $Value

  $Value = "    @level0type = N'SCHEMA', @level0name = 'abx',"
  Add-Content -Path $File -Value $Value

  $Value = "    @level1type = N'FUNCTION', @level1name = '" + $FunctionName + "';"
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

  $Value = "    @level0type = N'SCHEMA', @level0name = 'abx',"
  Add-Content -Path $File -Value $Value

  $Value = "    @level1type = N'FUNCTION', @level1name = '" + $FunctionName + "';"
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

  $Value = "    @level0type = N'SCHEMA', @level0name = 'abx',"
  Add-Content -Path $File -Value $Value

  $Value = "    @level1type = N'FUNCTION', @level1name = '" + $FunctionName + "';"
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

  $Value = "    @level0type = N'SCHEMA', @level0name = 'abx',"
  Add-Content -Path $File -Value $Value

  $Value = "    @level1type = N'FUNCTION', @level1name = '" + $FunctionName + "';"
  Add-Content -Path $File -Value $Value

  $Value = "GO"
  Add-Content -Path $File -Value $Value

  Add-Content -Path $File -Value ''
}

