# התחברות לאופיס 365 

$Cred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic –AllowRedirection
Import-PSSession $Session

#ייצוא הקבוצה לאקסל

Get-UnifiedGroup -Identity "allcompedia" |Get-UnifiedGroupLinks -LinkType Member |select Name,PrimarySMTPAddress |export-csv c:\O365GroupAllStaff.csv