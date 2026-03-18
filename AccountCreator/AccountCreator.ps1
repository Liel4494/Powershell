Write-Host " "
Write-Host " "

@"
 █████╗  ██████╗ ██████╗ ██████╗ ██╗   ██╗███╗   ██╗████████╗     ██████╗██████╗ ███████╗ █████╗ ████████╗ ██████╗ ██████╗ 
██╔══██╗██╔════╝██╔════╝██╔═══██╗██║   ██║████╗  ██║╚══██╔══╝    ██╔════╝██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗
███████║██║     ██║     ██║   ██║██║   ██║██╔██╗ ██║   ██║       ██║     ██████╔╝█████╗  ███████║   ██║   ██║   ██║██████╔╝
██╔══██║██║     ██║     ██║   ██║██║   ██║██║╚██╗██║   ██║       ██║     ██╔══██╗██╔══╝  ██╔══██║   ██║   ██║   ██║██╔══██╗
██║  ██║╚██████╗╚██████╗╚██████╔╝╚██████╔╝██║ ╚████║   ██║       ╚██████╗██║  ██║███████╗██║  ██║   ██║   ╚██████╔╝██║  ██║
╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝   ╚═╝        ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝

░░░░░░  ░░    ░░     ░░      ░░ ░░░░░░░ ░░           ░░░░░░  ░░░░░░  ░░   ░░ ░░░░░░░ ░░░    ░░ 
▒▒   ▒▒  ▒▒  ▒▒      ▒▒      ▒▒ ▒▒      ▒▒          ▒▒      ▒▒    ▒▒ ▒▒   ▒▒ ▒▒      ▒▒▒▒   ▒▒ 
▒▒▒▒▒▒    ▒▒▒▒       ▒▒      ▒▒ ▒▒▒▒▒   ▒▒          ▒▒      ▒▒    ▒▒ ▒▒▒▒▒▒▒ ▒▒▒▒▒   ▒▒ ▒▒  ▒▒ 
▓▓   ▓▓    ▓▓        ▓▓      ▓▓ ▓▓      ▓▓          ▓▓      ▓▓    ▓▓ ▓▓   ▓▓ ▓▓      ▓▓  ▓▓ ▓▓ 
██████     ██        ███████ ██ ███████ ███████      ██████  ██████  ██   ██ ███████ ██   ████ 
"@
Write-Host " "
Write-Host " "

#You need to run this command ON EVEY NEW PC\Laptop! 
#Read-Host -AsSecureString | ConvertFrom-SecureString | Out-File -Filepath Pa$$w0rd.securestring

#Chack For Updats
$IsTheLastVersion = git status
$IsTheLastVersion = $IsTheLastVersion -like "*Your branch is up to date*"
$Split = $IsTheLastVersion.Split(" ")

Write-Host "  "
Write-Host "Checking For Updates" -NoNewline
for ($num = 0 ; $num -le 2 ; $num++)
{
    
    Write-Host "." -NoNewline
    Start-Sleep 1
}

if ($Split -notcontains "up" -and $Split -notcontains "to" -and $Split -notcontains "date")
{
    Write-Host " " -NoNewline
    Write-Host "Update Needed." -ForegroundColor Black -BackgroundColor Red 
    Write-Host "Please Run 'Git Pull'. "
    Write-Host "   "
    Start-Sleep 5
    Exit 
}
else 
{ 
    Write-Host " " -NoNewline
    Write-Host " Up To Date." -ForegroundColor Black -BackgroundColor Green
    Write-Host "   " 
}


#Chack For missing Files
$GamSetUp = Test-Path -Path "client_secrets.json"
$IsTheFirstTime = Test-path -path "First.zibi"
$SenderAddressCreated = Test-path -path "SenderAddress.txt"
$GsuiteCredCreated = Test-path -path "Gmail.securestring"
$CcFileExist = Test-path -path "CC.txt"
$MailSignatureExist = Test-path -path "MailSignature.txt"
$Office365UsernameCreated = Test-path -path "Office365Username.txt"
$Offcie365CredCreated  = Test-path -path "Office365.securestring"
$ActiveDirectoryAdminUsernameCreated = Test-path -path "ADAdmin.txt"
$ActiveDirectoryAdminCredCreated = Test-path -path "ADAdmin.securestring"
$DomainControllerIP =  Test-path -path "DCIP.txt"

while ($GamSetUp -eq $false)
{
    Write-Host "Can't Find client_secrets.json File."
    Write-Host "You Must Set Up GAM Before Running The Script!" -BackgroundColor Yellow -ForegroundColor Black
    Write-Host "Please Set Up GAM By Running The gam-setup.bat File, And Run The Script Again."
    Start-Sleep -Seconds 15
    Exit


}

if ($IsTheFirstTime -ne $true) #if the First.zibi file not exist
{
    Write-Host "Welcome To Account Creator!"
    Write-Host " "
    Write-Host "If you running the script at the first time, know that you need to create credentials files to start the script."
    Write-Host "But don't worry, this is one time action, and I will help you."
    Write-Host " "
    Out-File -Filepath First.zibi
}

while ($SenderAddressCreated -eq $false)
{
    Write-Host "Can't Find Sender Address TXT File."
    Read-Host "Please Enter Your Gmail Address (this address will be used to send the email's to the new employee)" | Out-File -Filepath SenderAddress.txt    
    $SenderAddressCreated = Test-path -path "SenderAddress.txt"
}

while ($GsuiteCredCreated -eq $false)
{
    Write-Host " "
    Write-Host "Can't Find Gmail SecureString File."
    Read-Host "Please Enter Your Gmail Specific App password" -AsSecureString | ConvertFrom-SecureString | Out-File -Filepath Gmail.securestring    
    $GsuiteCredCreated = Test-path -path "Gmail.securestring"
}

while ($CcFileExist -eq $false)
{
    Write-Host " "
    Write-Host "Can't Find CC.txt File."
    Read-Host "Please Enter Email CC (Usually The HR Email)" | Out-File "CC.txt"
    Read-Host "Second Email CC: (Pesss Enter To Skip)" | Add-Content -path 'CC.txt'
    
    $CcFileExist = Test-path -path "CC.txt"
}

while ($MailSignatureExist -eq $false)
{
    Write-Host " "
    Write-Host "Can't Find MailSignature.txt File."
    Read-Host "Please Upload Your Email Signature As A Picture And Past The Direct Link Here " | Out-File "MailSignature.txt"
    $MailSignatureExist = Test-path -path "MailSignature.txt"
}

while ($Office365UsernameCreated -eq $false)
{
    Write-Host " "
    Write-Host "Can't Find Office365 Username File."
    Read-Host "Please Enter Your Office365 Account Username" | Out-File -Filepath Office365Username.txt    
    $Office365UsernameCreated = Test-path -path "Office365Username.txt"
}

while ($Offcie365CredCreated -eq $false)
{
    Write-Host " "
    Write-Host "Can't Find Office365 SecureString File."
    Read-Host "Please Enter Your Office365 Account password" -AsSecureString | ConvertFrom-SecureString | Out-File -Filepath Office365.securestring    
    $Offcie365CredCreated = Test-path -path "Office365.securestring"
}

while ($ActiveDirectoryAdminUsernameCreated -eq $false)
{
    Write-Host "Can't Find ADAdmin.txt File."
    Read-Host "Please Enter Your AD Admin Username (Domain\Username)" | Out-File -Filepath ADAdmin.txt    
    $ActiveDirectoryAdminUsernameCreated = Test-path -path "ADAdmin.txt"
}

while ($ActiveDirectoryAdminCredCreated -eq $false)
{
    Write-Host " "
    Write-Host "Can't Find ADAdmin.securestring File."
    Read-Host "Please Enter Your Active Directory Admin Password" -AsSecureString | ConvertFrom-SecureString | Out-File -Filepath ADAdmin.securestring    
    $ActiveDirectoryAdminCredCreated = Test-path -path "ADAdmin.securestring"
}

while ($DomainControllerIP -eq $false)
{
    Write-Host "Can't Find DCIP.txt File."
    Read-Host "Please Enter Your Domain Controller IP Address" | Out-File -Filepath DCIP.txt    
    $DomainControllerIP = Test-path -path "DCIP.txt"
}

$SenderAddress = Get-Content -path 'SenderAddress.txt'
$EmailSecureString = 'Gmail.securestring'
$CC = Get-Content -Path "CC.txt"
$MailSignature = Get-Content -Path "MailSignature.txt"
$office365Username = Get-Content -path 'Office365Username.txt'
$365SecureString = "Office365.securestring"
$ADAdminUserName = Get-Content -path "ADAdmin.txt"
$ADAdminPassword = "ADAdmin.securestring"


Write-Host " "
if ($IsTheFirstTime -eq $true) 
{
    Write-Host "Welcome To Account Creator!"    
}

Write-Host " "
Write-Host " "

$FirstName = Read-Host "Enter The New Employee First Name"
$LastName = Read-Host "Enter the Employee Last Name"
$phone = Read-Host "Enter The Employee phone Number (must start with area code!)"
$personalEmail = Read-Host "Enter The Employee personal Email"
$UserName = $FirstName+"."+$LastName
$DisplayName = $FirstName+" "+$LastName
$EmailAddress = $UserName+"@morphisec.com"
$Password =  ("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".tochararray() | Sort-Object {Get-Random})[0..12] -join ''

##########
# Gsuite #
##########

Write-Host " "
Write-Host "Do You Want To Create Gsuite Account?"
$Y = Read-Host "Enter Y Or N"

while (($Y -ne 'Y') -and ($Y -ne 'N') -and ($Y -ne 'y') -and ($Y -ne 'n'))
{
    $Y = Read-Host "Please Enter Only Y Or N"
}

if (($Y -eq 'Y') -or ($Y -eq "y"))
{
    #Check For Available Gsuite license
    $A = .\gam.exe report customer | Out-String
    $pos = $a.IndexOf("accounts:gsuite_basic_total_licenses,")
    $Len = ("accounts:gsuite_basic_total_licenses,").Length
    $S = $a.Substring($pos+$Len)
    $pos2 = $s.IndexOf(",")
    $GsuiteTotalicense = $S.Substring(0,$pos2)

    $pos = $a.IndexOf("accounts:gsuite_basic_used_licenses,")
    $Len = ("accounts:gsuite_basic_used_licenses,").Length
    $S = $a.Substring($pos+$Len)
    $pos2 = $s.IndexOf(",")
    $GsuiteUsedlicense = $S.Substring(0,$pos2)

    $GsuiteAvailableLicenses = $GsuiteTotalicense - $GsuiteUsedlicense
    Write-Host " "
    Write-Host " "
    Write-Host "The Available Gsuite License Number is:" $GsuiteAvailableLicenses
    Write-Host "(Notice That The Number Could Be Wrong! It's Take Time To Google API To Updated)"
    Write-Host " "

    #Create Gsuite Account GAM:
    .\gam.exe create user $UserName firstname $FirstName Lastname $LastName password $password changepassword on recoveryphone $phone *> GsuiteAccountLog.txt  
    $GsuiteAccountLog = Get-Content -Path 'GsuiteAccountLog.txt'
    #Add Gsuite Basic license:
    .\gam.exe user $EmailAddress add license gsuitebasic *> GsuiteLicenseLog.txt
    $GsuiteLicenseLog = Get-Content -Path 'GsuiteLicenseLog.txt'
    #Get User Backupcode:
    $AlBackupcodes = .\gam.exe user $EmailAddress update backupcodes | Out-String
    $Backupcode = $AlBackupcodes.Substring($AlBackupcodes.Length-12)
    #Add user to all@Morphise.com
    .\gam.exe update group all@morphisec.com add member $EmailAddress | out-null
    
    if (($GsuiteAccountLog -like '*error*') -or ($GsuiteLicenseLog -like '*error*'))
    {
        Write-Host " "
        Write-Host "There Is A Problam To Create Gsuite Account, Make Sure Ther Is No Duplicated Accounts,"
        Write-Host "And You Entered All The Details Correctly"
        Write-Host " "
        $GsuiteAccountLog
        Write-Host " "

    }
    
    else
    {
        Write-Host "Creating Gsuite Account..."
        start-Sleep 3
        Write-Host "Adding License..."
        start-Sleep 3
        Write-Host "Gsute Account Created and added To 'All' Group Successfully!"

    #Send Gsuite Account Credentials To The New Employee #
    
    $To = $personalEmail
    $From =  $SenderAddress
    $Cc = Get-Content -Path "CC.txt"
    $Subject =  "Get started with your new Morphisec Email"

    #For Help With HTMl See https://htmled.it/
    $Body = [string]::Format('<p style="text-align: left;">Hey {0}, A big congratulations on your new role!<br />On behalf of the IT department,we would like to say congrats and welcome aboard.</p>
    <p style="text-align: left;">The first step to sing at Morphisec is setting up an email account, creating a password, and connecting your phone.</p>',$FirstName)
    $Body += [string]::Format('<p style="text-align: left;">Here''s how:</p>')
    $Body += [string]::Format('<p style="text-align: left;">1. log in to your new Morphisec email (<a href="https://mail.google.com">Gmail.com</a>): <br /><strong>  Your personal address is:</strong> {0} <br /><strong>  Temporary password:</strong> {1}</p>',$EmailAddress,$password)
    $Body += [string]::Format('<p style="text-align: left;">2. Connect your account to your phone by a <strong> Two-factor authentication </strong> ( <strong> 2FA </strong> ).<br />  For an explanation on how to do so - <a href="https://www.google.com/landing/2step/" data-saferedirecturl="https://www.google.com/url?q=https://www.google.com/landing/2step/&amp;source=gmail&amp;ust=1643275481487000&amp;usg=AOvVaw02GiVKFlKQaHOpc4kKkWe-"> click here </a> <br />  Your backup security code: {0}</p>',$Backupcode)
    $Body += [string]::Format('<p style="text-align: left;">If you have any questions or need help, please contact us , IT.</p>')
    $Body += [string]::Format('<p style="text-align: left;"><img src="{0}" /></p>',$MailSignature)

    $mail = New-Object System.Net.Mail.Mailmessage $From, $To, $Subject, $Body
    $mail.IsBodyHTMl=$true
    $server = "smtp.gmail.com"
    
    #Use this command to create securestring file that contain the your email password:
    #Read-Host -AsSecureString | ConvertFrom-SecureString | Out-File -Filepath username@domain.com.securestring 
    #https://rcmtech.wordpress.com/2016/03/03/send-smtp-email-with-authentication-from-powershel/
    
    $EncryptedpasswordFile = $EmailSecureString
    $SecureStringpassword = Get-Content -path $EncryptedpasswordFile | ConvertTo-SecureString
    $EmailCredential = New-Object -TypeName System.Management.Automation.pSCredential -Argumentlist $From,$SecureStringpassword
    
    # Send send the Mail
    Send-MailMessage -From $From -To $personalEmail -Cc $CC -Subject $Subject -Body $Body -SmtpServer $server -BodyAsHtml -UseSsl -Credential $EmailCredential
    
    Write-Host "  "
    Write-Host "Gsuite Credentials Sent To The Employee personal Email Successfully!" -BackgroundColor Green -ForegroundColor Black
    Write-Host "The Email Sent To The HR's As A 'CC' Copy. (If Fill The CC.txt File Correctly.)" -BackgroundColor Green -ForegroundColor black
    
    }   
    Remove-Item -Path 'GsuiteAccountLog.txt'
    Remove-Item -Path 'GsuiteLicenseLog.txt'
}

##############
# Office 365 #
##############

Write-Host " "
Write-Host "Do You Want To Create Office 365 Account?"
$Y = Read-Host "Enter Y Or N"

while (($Y -ne 'Y') -and ($Y -ne 'N') -and ($Y -ne 'y') -and ($Y -ne 'n'))
{
    $Y = Read-Host "Please Enter Only Y Or N"
}


if (($Y -eq 'Y') -or ($Y -eq 'y'))
{
    $User = $Office365Username
    $EncryptedpasswordFile = $365SecureString
    $SecureStringpassword = Get-Content -path $EncryptedpasswordFile | ConvertTo-SecureString
    $Cred = New-Object -TypeName System.Management.Automation.pSCredential -Argumentlist $User,$SecureStringpassword

    Connect-MsolService -Credential $Cred
    
    #Check for available license.
    $365licenseNumber = Get-MsolAccountSku | Where-Object {$_.AccountSkuId -like "morphisec0:O365_BUSINESS"} | Select-Object -Expandproperty 'ActiveUnits'
    $365licenseInuse = Get-MsolAccountSku | Where-Object {$_.AccountSkuId -like "morphisec0:O365_BUSINESS"} | Select-Object -Expandproperty 'ConsumedUnits'
    
    If($365licenseNumber-$365licenseInuse -gt 0)
    {
        $365Account = New-MsolUser -DisplayName $DisplayName -FirstName $FirstName -LastName $LastName -UserprincipalName $EmailAddress -Usagelocation "Il" -licenseAssignment morphisec0:O365_BUSINESS
        $365UserName =  $365Account | Select-Object -Expandproperty 'UserprincipalName'
        $365Userpassword =  $365Account | Select-Object -Expandproperty 'password'
        Write-Host " "
        Write-Host "Office 365 Account Created Successfully!"
    }


    else
    {
        While ($365licenseNumber-$365licenseInuse -eq 0)
        {
            $365licenseNumber = Get-MsolAccountSku | Where-Object {$_.AccountSkuId -like "morphisec0:O365_BUSINESS"} | Select-Object -Expandproperty 'ActiveUnits'
            $365licenseInuse = Get-MsolAccountSku | Where-Object {$_.AccountSkuId -like "morphisec0:O365_BUSINESS"} | Select-Object -Expandproperty 'ConsumedUnits'
            
            Write-Host "You're Out Of licenses! Go Buy One In The Pop Up Window"
            start-process "https://admin.microsoft.com/Adminportal/Home?source=aplauncher#/subscriptions/webdirect/fa501566-cffe-4f95-98c0-e4ee3725ee71"
            Read-Host "Press Enter When You Done"
            write-host "Checking For Available license" -NoNewline
            
            While ($365licenseNumber - $365licenseInuse -eq 0) {
                $365licenseNumber = Get-MsolAccountSku | Where-Object { $_.AccountSkuId -like "morphisec0:O365_BUSINESS" } | Select-Object -Expandproperty 'ActiveUnits'
                $365licenseInuse = Get-MsolAccountSku | Where-Object { $_.AccountSkuId -like "morphisec0:O365_BUSINESS" } | Select-Object -Expandproperty 'ConsumedUnits'
                write-host "." -nonewline
                Start-Sleep 0.5
            }

        }
        
        $365Account = New-MsolUser -DisplayName $DisplayName -FirstName $FirstName -LastName $LastName -UserprincipalName $EmailAddress -Usagelocation "Il" -licenseAssignment morphisec0:O365_BUSINESS
        $365UserName =  $365Account | Select-Object -Expandproperty 'UserprincipalName'
        $365Userpassword =  $365Account | Select-Object -Expandproperty 'password'
        Write-Host " "
        Write-Host "Office 365 Account Created Successfully!"
        Write-Host " "
    }
   
    
    # Send 365 Account Credentials To The New Employee 
    
    $To = $EmailAddress
    $From = $SenderAddress
    $Subject = "New Office 365 Account"
    
    #For Help With HTMl See https://htmled.it/
    $Body = [string]::Format('<p style="text-align: left;">Hey {0},</p>',$FirstName)
    $Body += [string]::Format('<p style="text-align: left;">here are your license details for office 365:</p>')
    $Body += [string]::Format('<p style="text-align: left;"><strong>Username: </strong>{0}</p>',$365UserName)
    $Body += [string]::Format('<p style="text-align: left;"><strong>Password: </strong>{0}</p>',$365Userpassword)
    $Body += [string]::Format('<p style="text-align: left;"></p>')
    $Body += [string]::Format('<p style="text-align: left;"></p>')
    $Body += [string]::Format('<h3 style="text-align: left;"><u>To Download Office 365:</u></h3>
    <p style="text-align: left;">1.Go to <a href="https://www.office.com">https://www.office.com</a> and connect with your credential.</p>
    <p style="text-align: left;">2. Click on <strong>Instal Office&gt;premium Office aps.</strong><strong></strong></p>
    <p style="text-align: left;"><strong><img src="https://i.imgur.com/g7avvT7.png" alt="" /></strong></p>
    <p style="text-align: left;"><strong></strong></p>
    <p style="text-align: left;"><img src="{0}" /></p>',$MailSignature)
    
     $mail = New-Object System.Net.Mail.Mailmessage $From, $To, $Subject, $Body
     $mail.IsBodyHTMl=$true
     $server = "smtp.gmail.com"
     
     #Use this command to create securestring file that contain the your email password:
     #Read-Host -AsSecureString | ConvertFrom-SecureString | Out-File -Filepath username@domain.com.securestring 
     #https://rcmtech.wordpress.com/2016/03/03/send-smtp-email-with-authentication-from-powershel/
     
     $EncryptedpasswordFile = $EmailSecureString
     $SecureStringpassword = Get-Content -path $EncryptedpasswordFile | ConvertTo-SecureString
     $EmailCredential = New-Object -TypeName System.Management.Automation.pSCredential -Argumentlist $From,$SecureStringpassword
     
     # Send send the Mail
     Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer $server -BodyAsHtml -UseSsl -Credential $EmailCredential
     Write-Host " "
     Write-Host "Office 365 Credentials Sent To The Employee Morphisec Email Successfully!" -BackgroundColor Green -ForegroundColor Black
}


#########
# Slack #
#########

Write-Host " "
Write-Host "Do You Want To Invite The Employee To Morphisec Slack Workpace?"
$Y = Read-Host "Enter Y Or N"

while (($Y -ne 'Y') -and ($Y -ne 'N') -and ($Y -ne 'y') -and ($Y -ne 'n'))
{
    $Y = Read-Host "Please Enter Only Y Or N"
}


if (($Y -eq 'Y') -or ($Y -eq 'y'))
{
    Set-Clipboard -Value $EmailAddress
    Write-Host "  The New Employee Email Address Copyed To The Clipboard!  " -BackgroundColor Yellow -ForegroundColor Black
    Write-Host "In The Pop Up Window, Click On 'Invite Pepole' Button And Past The Email Address."-BackgroundColor Yellow -ForegroundColor Black
    start-process "https://morphisec.slack.com/admin"
    Start-Sleep -Seconds 15
}


####################
# Active Directory #
####################

Write-Host " "
Write-Host "Do You Want To Create Active Directory User? (If You Are Not In The Office,Make Sure You Connected To VPN!)"
$Y = Read-Host "Enter Y Or N"

while (($Y -ne 'Y') -and ($Y -ne 'N') -and ($Y -ne 'y') -and ($Y -ne 'n'))
{
    $Y = Read-Host "Please Enter Only Y Or N"
}


if (($Y -eq 'Y') -or ($Y -eq 'y'))
{
    $EncryptedpasswordFile = $ADAdminPassword
    $SecureStringpassword = Get-Content -path $EncryptedpasswordFile | ConvertTo-SecureString
    $ADCredentials = New-Object -TypeName System.Management.Automation.pSCredential -Argumentlist $ADAdminUserName,$SecureStringpassword


    Invoke-Command -ComputerName 192.168.0.77 -Credential $ADCredentials -ArgumentList $FirstName,$LastName,$DisplayName,$UserName -ScriptBlock{
        param($FirstName,$LastName,$DisplayName,$UserName)
        $ADPassword = Convertto-securestring ($FirstName.Substring(0,1).ToUpper() + $LastName.Substring(0,1) + "123!@#" ) -AsPlainText -Force
        New-ADUser -Name $DisplayName -GivenName $FirstName -Surname $LastName -SamAccountName $UserName -UserPrincipalName $UserName"@ad.morphisec.com" -Path "OU=Morphisec_Users,DC=ad,DC=morphisec,DC=Com" -AccountPassword $ADPassword -PasswordNeverExpires $true -EmailAddress "$UserName@morphisec.com"
        Enable-ADAccount -Identity $UserName
    }

    Write-Host "Active Directory Account Created Successfully!" -ForegroundColor Black -BackgroundColor Green
}

Start-Sleep 3

