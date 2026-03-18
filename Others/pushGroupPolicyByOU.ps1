$list = Get-ADComputer -SearchBase "OU=Compedia's Computers,dc=gordi,dc=com" -Filter * | Select -Exp dnshostname
$i = 1

foreach ($list in $list)

    {
       Write-Host $i .$list #כותב את שם המחשב שעליו הסקריפט רץ+מספר מהמונה
        
       Invoke-GPUpdate -Computer $list

       $i++ #מונה עולה ב-1
    }
