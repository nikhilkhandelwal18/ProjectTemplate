Param ($Server, $DB, $User, $Pwd)

$ScriptPath = '.\'

$LogFile = '.\' + $DB + '.log'

$Files = Get-ChildItem -Path $ScriptPath -File -Recurse -Filter "*.sql"

New-Item -Path $Logfile -ItemType File -Force | Out-Null

foreach ($File in $Files)
{
  $LogLine = $File.FullName
  Write-Output $LogLine | Out-File -FilePath $Logfile  -Append

  Invoke-Sqlcmd -InputFile $File.FullName -ServerInstance $Server -TrustServerCertificate  -Database $DB -Username $User -Password $Pwd 
}