Connect-MSOLService
Set-MsolUser -UserPrincipalName Liel.cohen@q4d.io -PasswordNeverExpires $true


#Get-MSOLUser -UserPrincipalName  | Select PasswordNeverExpires
