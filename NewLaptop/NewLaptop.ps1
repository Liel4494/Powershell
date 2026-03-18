Write-Host " "
Write-Host " "

@"
███╗   ██╗███████╗██╗    ██╗    ██╗      █████╗ ██████╗ ████████╗ ██████╗ ██████╗     ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗
████╗  ██║██╔════╝██║    ██║    ██║     ██╔══██╗██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝
██╔██╗ ██║█████╗  ██║ █╗ ██║    ██║     ███████║██████╔╝   ██║   ██║   ██║██████╔╝    ███████╗██║     ██████╔╝██║██████╔╝   ██║   
██║╚██╗██║██╔══╝  ██║███╗██║    ██║     ██╔══██║██╔═══╝    ██║   ██║   ██║██╔═══╝     ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   
██║ ╚████║███████╗╚███╔███╔╝    ███████╗██║  ██║██║        ██║   ╚██████╔╝██║         ███████║╚██████╗██║  ██║██║██║        ██║   
╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚══════╝╚═╝  ╚═╝╚═╝        ╚═╝    ╚═════╝ ╚═╝         ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   

░░░░░░  ░░    ░░     ░░      ░░ ░░░░░░░ ░░           ░░░░░░  ░░░░░░  ░░   ░░ ░░░░░░░ ░░░    ░░ 
▒▒   ▒▒  ▒▒  ▒▒      ▒▒      ▒▒ ▒▒      ▒▒          ▒▒      ▒▒    ▒▒ ▒▒   ▒▒ ▒▒      ▒▒▒▒   ▒▒ 
▒▒▒▒▒▒    ▒▒▒▒       ▒▒      ▒▒ ▒▒▒▒▒   ▒▒          ▒▒      ▒▒    ▒▒ ▒▒▒▒▒▒▒ ▒▒▒▒▒   ▒▒ ▒▒  ▒▒ 
▓▓   ▓▓    ▓▓        ▓▓      ▓▓ ▓▓      ▓▓          ▓▓      ▓▓    ▓▓ ▓▓   ▓▓ ▓▓      ▓▓  ▓▓ ▓▓ 
██████     ██        ███████ ██ ███████ ███████      ██████  ██████  ██   ██ ███████ ██   ████                                                                                                                                
"@


#Connect To Wifi Network
Enable-NetAdapter -Name Wi-fi -Confirm:$false
Start-Sleep 8
.\Set-NetAdapterRadioPowerState.ps1 -WifiStatus On

$profilefile= "WifiProfile.xml"
$SSID= Get-Content "SSID.TXT"
$PW = Get-Content "WiFi Password.TXT"

$SSIDHEX=($SSID.ToCharArray() | foreach-object {'{0:X}' -f ([int]$_)}) -join''
$xmlfile="<?xml version=""1.0""?>
<WLANProfile xmlns=""http://www.microsoft.com/networking/WLAN/profile/v1"">
    <name>$SSID</name>
    <SSIDConfig>
        <SSID>
            <hex>$SSIDHEX</hex>
            <name>$SSID</name>
        </SSID>
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>WPA2PSK</authentication>
                <encryption>AES</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
            <sharedKey>
                <keyType>passPhrase</keyType>
                <protected>false</protected>
                <keyMaterial>$PW</keyMaterial>
            </sharedKey>
        </security>
    </MSM>
</WLANProfile>
"

$XMLFILE > ($profilefile)
netsh wlan add profile filename="$($profilefile)"
netsh wlan show profiles $SSID key=clear | Out-Null
netsh wlan connect name=$SSID

Write-Host "  "
Start-Sleep 4
Write-Host "Connected To MorphiGuest WiFi network"
Write-Host "  "
Write-Host "  "
Write-Host "Check For Updates?"
Write-Host "If The Laptop/PC Don't Have Git Installed, You Can't Check For Updates." -background Yellow -ForegroundColor Black
$Y = Read-Host "Enter Y Or N"
while (($Y -ne 'Y') -and ($Y -ne 'N') -and ($Y -ne 'y') -and ($Y -ne 'n'))
{
    $Y = Read-Host "Please Enter Only Y Or N"
}

if (($Y -eq 'Y') -or ($Y -eq "y"))
{
    #Chack For Updats
    $IsTheLastVersion = git status
    $IsTheLastVersion = $IsTheLastVersion -like "*Your branch is up to date*"

    Write-Host "  "
    Write-Host "Checking For Updates" -NoNewline
    for ($num = 0 ; $num -le 2 ; $num++)
    {
        
        Write-Host "." -NoNewline
        Start-Sleep 1
    }

    if ($IsTheLastVersion -notcontains "Your branch is up to date with 'New-Laptop-Scipt/master'.")
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
}

#Check For Missing Files
$IfExist = Test-Path "Printer Driver"
while ($IfExist -eq $false)
{
    Write-Host "  "
    Write-Host "Can't Find Printer Driver Folder."
    Write-Host "You Must Save Printer Driver In Folder Named 'Printer Driver'" 
    Write-Host "Run The Script Again When You Done."
    Start-Sleep -Seconds 15
    Exit
}

$IfExist = Test-Path "Installation Token.txt"
while ($IfExist -eq $false)
{
    Write-Host "  "
    Write-Host "Can't Find 'Installation Token.txt' File."
    Write-Host "Please Create TXT File With the Installation Token In It." 
    Write-Host "Run The Script Again When You Done."
    Start-Sleep -Seconds 15
    Exit
}

$IfExist = Test-Path "WifiProfile.xml"
while ($IfExist -eq $false)
{
    Write-Host "  "
    Write-Host "Can't Find 'WifiProfile.xml' File."
    Write-Host "  "
    Write-Host "Please Export XML File From PC\Laptop That already Connected to the Desired WiFi Network." 
    Write-Host "You Can Use This Powershell Command:"
    Write-Host "netsh wlan export profile "Enter The SSID To Export" key=clear folder=c:" -BackgroundColor Gray -ForegroundColor Black
    Write-Host "  "
    Write-Host "Run The Script Again When You Done."
    Start-Sleep -Seconds 15
    Exit
}

$IfExist = Test-Path "SSID.TXT"
while ($IfExist -eq $false)
{
    Write-Host "  "
    Write-Host "Can't Find 'SSID.txt' File."
    Read-Host "Please Enter Your WiFi SSID" | Out-File "SSID.txt"
    $IfExist = Test-Path "SSID.txt"
}

$IfExist = Test-Path "WiFi Password.txt"
while ($IfExist -eq $false)
{
    Write-Host "  "
    Write-Host "Can't Find 'WiFi Password.TXT' File."
    Read-Host "Please Enter WiFi Password" | Out-File "WiFi Password.txt"
    $IfExist = Test-Path "WiFi Password.txt"
}

$IfExist = Test-Path "MorphisecProtectorInstaller.exe"
while ($IfExist -eq $false)
{
    Write-Host "  "
    Write-Host "Can't Find 'MorphisecProtectorInstaller.exe' File."
    Write-Host "You Must Save The Protector Installation File Under The Name 'MorphisecProtectorInstaller.exe'."
    Write-Host "Run The Script Again When You Done."
    Start-Sleep -Seconds 15
    Exit
}

$IfExist = Test-Path "Token.json"
while ($IfExist -eq $false)
{
    Write-Host "  "
    Write-Host "Can't Find 'Token.json' File."
    Write-Host "You Must Have Token.json File With Client Token In It."
    Write-Host "Run The Script Again When You Done."
    Start-Sleep -Seconds 15
    Exit
}

$IfExist = Test-Path "Printer IP.txt"
while ($IfExist -eq $false)
{
    Write-Host "  "
    Write-Host "Can't Find 'Printer IP.txt' File."
    Read-Host "Please Enter Printer IP Address" | Out-File "Printer IP.txt"
    $IfExist = Test-Path "Printer IP.txt"
}

$GamSetUpExist = Test-Path -Path "client_secrets.json"
while ($GamSetUpExist -eq $false)
{
    Write-Host " "
    Write-Host "Can't Find client_secrets.json File."
    Write-Host "You Must Set Up GAM Before Running The Script!" -BackgroundColor Yellow -ForegroundColor Black
    Write-Host "Please Set Up GAM By Running The gam-setup.bat File, And Run The Script Again."
    Start-Sleep -Seconds 15
    Exit
}

$SenderAddressExist = Test-path -path "SenderAddress.txt"
while ($SenderAddressExist -eq $false)
{
    Write-Host " "
    Write-Host "Can't Find Sender Address File."
    Read-Host "Please Enter Your Gsuite Email Address" | Out-File -Filepath "SenderAddress.txt"
    $SenderAddressExist = Test-path -path "SenderAddress.txt"
}

$GsuiteCredExist = Test-path -path "Gmail.securestring"
while ($GsuiteCredExist -eq $false)
{
    Write-Host " "
    Write-Host "Can't Find  Gmail SecureString File."
    Read-Host "Please Enter Your Spesific App Password" -AsSecureString | ConvertFrom-SecureString | Out-File -Filepath Gmail.securestring
    $GsuiteCredExist = Test-path -path "Gmail.securestring"
}

$MailSignatureExist = Test-path -path "MailSignature.txt"
while ($MailSignatureExist -eq $false)
{
    Write-Host " "
    Write-Host "Can't Find Mail Signature File."
    Read-Host "Please Upload Your Email Signature As A Picture And Past The Direct Link Here " | Out-File -Filepath "MailSignature.txt"
    $MailSignatureExist = Test-path -path "MailSignature.txt"
}

$TokenInstructionExist = Test-path -path "New VPN Token use.docx"
while ($TokenInstructionExist -eq $false)
{
    Write-Host " "
    Write-Host "Can't Find 'New VPN Token use.docx' File."
    Read-Host "You Must Have File Named 'New VPN Token use.docx', The File Should Contain VPN Connect Instrucrion."
    $TokenInstructionExist = Test-path -path "New VPN Token use.docx"
}

Write-Host "  "
Write-Host "  "
$Firstname = Read-host "Enter The Employee Firts Name"
$LastName = Read-host "Enter The Employee Last Name"
$LaptopModel = Read-host "Enter Laptop Model Number"

$Username = $Firstname + "." + $LastName
$UserPassword = ($Firstname.Substring(0,1)).ToUpper() + ($LastName.Substring(0,1)).ToLower() + "123!@#"
$NewHostName = ($Firstname.Substring(0,1)).ToUpper() + ($Firstname.Substring(1,$Firstname.Length-1)).ToLower() + ($LastName.Substring(0,1)).ToUpper() + "-" + $LaptopModel

#Send VPN Token Instruction Page

Write-Host "Do You Want To Sent VPN Instruction To Employee Email? "
$Y = Read-Host "Enter Y Or N"
while (($Y -ne 'Y') -and ($Y -ne 'N') -and ($Y -ne 'y') -and ($Y -ne 'n'))
{
    $Y = Read-Host "Please Enter Only Y Or N"
}

if (($Y -eq 'Y') -or ($Y -eq "y"))
{

    #Get The Email Address From Gsuite
    .\gam.exe print users query "name:$Firstname"
    Write-Host " "
    $EmployeeEmailAddress = Read-Host "Copy Here The Employee Email Address"

    #Send The VM Detailes To The Employee
    $SenderAddress = Get-Content 'SenderAddress.txt'
    $MailSignature = Get-Content 'MailSignature.txt'
    $Attachment = 'New VPN Token use.docx'

    $To = $EmployeeEmailAddress
    $From =  $SenderAddress
    $Subject = "VPN Token Instruction"

    #For Help With HTMl See https://htmled.it/
    $Body = [string]::Format('<p style="text-align: left;">Hi {0}!</p>',$Firstname)
    $Body += [string]::Format('<p style="text-align: left;">Here Is The Instruction To Use VPN Token:</p>')
    $Body += [string]::Format('<p></p>')
    $Body += [string]::Format('<p></p>')
    $Body += [string]::Format('<p style="text-align: left;"><img src="{0}" /></p>',$MailSignature)

    $mail = New-Object System.Net.Mail.Mailmessage $From, $To, $Subject, $Body
    $mail.IsBodyHTMl=$true
    $server = "smtp.gmail.com"

    #Use this command to create securestring file that contain the your email password:
    #Read-Host -AsSecureString | ConvertFrom-SecureString | Out-File -Filepath username@domain.com.securestring 
    #https://rcmtech.wordpress.com/2016/03/03/send-smtp-email-with-authentication-from-powershel/

    $EmailSecureString = 'Gmail.securestring'
    $EncryptedpasswordFile = $EmailSecureString
    $SecureStringpassword = Get-Content -path $EncryptedpasswordFile | ConvertTo-SecureString
    $EmailCredential = New-Object -TypeName System.Management.Automation.pSCredential -Argumentlist $From,$SecureStringpassword

    # Send send the Mail
    Send-MailMessage -From $From -To $EmployeeEmailAddress -Subject $Subject -Body $Body -Attachments $Attachment -SmtpServer $server -BodyAsHtml -UseSsl -Credential $EmailCredential
}

#Create the new user and add user him to Administrators group
net user $Username $UserPassword /add /Y /expires:never | Out-Null
net localgroup administrators $Username /add | Out-Null
Remove-LocalGroupMember -Group "users" -Member $Username
Write-Host " "
$Massage = "The User " + $Username + " created and added to the administrators Group."
Write-Host $Massage
Start-Sleep 2

#Change the hostname
Rename-Computer -NewName $NewHostName 
Write-Host " "
$Massage = "The system hostname will changed to " + $NewHostName + " after reboot"
Write-Host $Massage
Start-Sleep 2

#Install the protector
$InstallationToken = Get-Content "Installation Token.txt"
$ClientToken = Get-Content "Token.json"
Copy-Item "MorphisecProtectorInstaller.exe" -Destination "C:\MorphisecProtectorInstaller.exe"
Start-Sleep 2
c:\MorphisecProtectorInstaller.exe /token:$InstallationToken REGISTRATION_TOKEN=$ClientToken /passive

Write-Host "  "
Write-Host "The Protector installed in the background now. Please Wait Few Seconds..." 


#Enable Bitlocker 
New-Item -Name $NewHostName -ItemType "directory" | Out-Null
$FullPath = (Get-Location).Path + '\' +$NewHostName + '\' + 'bitlockerkey.txt'

Get-BitLockerVolume c: | Enable-BitLocker -SkipHardwareTest -UsedSpaceOnly -RecoveryPasswordProtector | Out-Null
$EncryptionPercentage = Get-BitLockerVolume c: | Select-Object -ExpandProperty EncryptionPercentage
Write-Host " "
Write-Host "Bitlocker Enabled."
Write-Host "Encripting The Drive Now." -NoNewline
While ($EncryptionPercentage -ne '100')
{
    $EncryptionPercentage = Get-BitLockerVolume c: | Select-Object -ExpandProperty EncryptionPercentage
    Write-Host "." -NoNewline
    Start-Sleep 1
}
Write-Host "Done" -NoNewline
Add-BitLockerKeyProtector -MountPoint c: -TpmProtector


#Save the recovery key. 
(Get-BitLockerVolume -MountPoint c).keyprotector.recoverypassword > $FullPath

Write-Host "  "
$Massage = "Bitlocker enabled and the recovery key created unter the " + $NewHostName + " folder"
Write-Host $Massage

#Add Office Printer  
$PrinterIP = Get-Content "Printer IP.txt"
$PrinterDriverPath = (Get-Location).Path + '\' + 'Printer Driver' 
Set-Location $PrinterDriverPath
.\Install.exe .\Install.exe /n'"Office Printer"' /sm$PrinterIP /q /h
Set-Location ..
Write-Host " "
Write-Host "Installing The Printer, Wait Few Secondes..."
Start-Sleep 30

#Set Office Printer As Default
$printer = Get-CimInstance -Class Win32_Printer -Filter "Name='Office Printer'"
Invoke-CimMethod -InputObject $printer -MethodName SetDefaultPrinter

Write-Host "  "
Write-Host "Office Printer added and set as default printer"

#Print New Laptop Latter
$FilePath = (Get-Location).Path + '\' + 'New Laptop Letter.docx'
$NewFilePath = (Get-Location).Path + '\' + 'Temp.Docx'
Copy-Item $FilePath -Destination $NewFilePath

Function OpenWordDoc($Filename)
{
    $Word=NEW-Object -comobject Word.Application
    Return $Word.documents.open($Filename)
}

$Doc=OpenWordDoc -Filename $NewFilePath


Function SearchAWord($Document,$findtext,$replacewithtext)
{ 
  $FindReplace=$Document.ActiveWindow.Selection.Find
  $matchCase = $false;
  $matchWholeWord = $True;
  $matchWildCards = $false;
  $matchSoundsLike = $false;
  $matchAllWordForms = $false;
  $forward = $true;
  $format = $false;
  $matchKashida = $false;
  $matchDiacritics = $false;
  $matchAlefHamza = $false;
  $matchControl = $false;
  $read_only = $false;
  $visible = $true;
  $replace = 2;
  $wrap = 1;
  $FindReplace.Execute($findText, $matchCase, $matchWholeWord, $matchWildCards, $matchSoundsLike, $matchAllWordForms, $forward, $wrap, $format, $replaceWithText, $replace, $matchKashida ,$matchDiacritics, $matchAlefHamza, $matchControl)
}

SearchAWord -Document $Doc -findtext '**FirstName**' -replacewithtext $Firstname | Out-Null
SearchAWord -Document $Doc -findtext '**LastName**' -replacewithtext $LastName | Out-Null
SearchAWord -Document $Doc -findtext '**Password**' -replacewithtext $UserPassword | Out-Null


Function SaveWordDoc($Document)
{
    $Document.Save()
    $Document.close()
}

SaveWordDoc -document $Doc


Start-Process -Filepath $NewFilePath -verb print
Start-Sleep -Seconds 5
Write-Host " "
Write-Host "New Laptop Letter document sent to office printer new. Get up and take it from the printer." -BackgroundColor Yellow -ForegroundColor Black

Start-Sleep 5
Remove-Item $NewFilePath
Remove-Item "c:\MorphisecProtectorInstaller.exe"
