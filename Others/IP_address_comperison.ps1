#הסקריפט לוקח רשימת אתרים מקובץ טקסט ומשווה את הכתובות לכתובת אייפי אחת 

$list = Get-Content -Path C:\Users\noc5\Desktop\addresses.txt
$i = 1
$server = "82.166.246.25"

ForEach ($ip in $list)
{
    Write-Host $i . $ip -ForegroundColor Cyan
    $temp = (Test-Connection -comp $ip -Count 1).ipv4address.ipaddressToString
    $server -eq $temp

    Write-Host "site ip:   " $temp
    Write-Host "server ip: " $server
    Write-Host " "
    Write-Host " "
    $i++ 
    

}
