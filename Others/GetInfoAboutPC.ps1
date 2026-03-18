$list = Get-Content -Path .\1.txt
$i = 1


foreach ($x in $list)
{
    $system_info = (systeminfo /fo csv | ConvertFrom-Csv | select os*).'os name' #מראה את גרסאת מערכת ההפעלה 
    $user_info = (Get-WMIObject -class Win32_ComputerSystem).username #מראה את שם המחשב והמשתמש 
    $office_info_x64 =  (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where {$_.DisplayName -like "*Office*"}).DisplayName | Select -first 1 # מראה את גירסאת האופיס
    $office_info_x32 = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where {$_.DisplayName -like "*Office*"}).DisplayName | Select -first 1
    $servicepack = (systeminfo /fo csv | ConvertFrom-Csv | select os*).'os version'
    $mail_info = Get-ChildItem -Path  $env:USERPROFILE\AppData\Local\Microsoft\Outlook\*  -Include *.ost, *.pst | Select-Object name,"    ",length #מראה קבצי נתונים של אאוטלוק
    
    Write-Host "$i.computer name & username: $user_info" -ForegroundColor Cyan 

    Write-Host " "
    
    write-host "operation system: " $system_info -ForegroundColor Red

    Write-Host " "

    write-host "service pack: " $servicepack -ForegroundColor Red

    Write-Host " "

    Write-Host "office x64 version: " $office_info_x64 -ForegroundColor Green

    Write-Host " "

    Write-Host "office x32 version: " $office_info_x32 -ForegroundColor Green

    Write-Host " "
    
    Write-Host "mailbox: " -ForegroundColor Yellow 
    
    $mail_info 

    $i += 1
    
    
   
}

Read-Host "press enter to see mailboxes"
Read-Host " "




