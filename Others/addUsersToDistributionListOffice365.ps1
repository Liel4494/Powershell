
#לפני הרצת הסקריפט,חובה ליצור קבוצה בשם זהה באופיס 365
#קובץ הטקסט מכיל רשימה של מיילים שאותם אנו רוצים להכניס לרשימת התפוצה


#התחברות לאופיס 365
$Cred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Cred -Authentication Basic –AllowRedirection
Import-PSSession $Session

$list=Get-Content 'C:\Users\lielc\Desktop\list.txt'

foreach ($mail in $list)
{
  Add-DistributionGroupMember -Identity "6 Floor" -Member $mail
}
