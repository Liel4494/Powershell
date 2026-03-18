
# 1. Winrm quickconfig -quiet :קודם כל לעשות על כל מחשב את הפקודה הזאת
# 2. firewall-ב Windows Remote Management את החוק gpo לפתוח באמצעות
# 3. c$-להפעיל גילוי ברשת כדי שתהיה גישה ב 
# 4. לא לשכוח לעשות קבצי התקנה אוטומטיים
# 

$computer =  Get-ADComputer -SearchBase 'OU=new ou,dc=Liel,dc=com' -Filter * | Select -Exp dnshostname  # שבו נפיץ את התוכנה OU-ה

$i = 1 #(מוסיף מספר ליד כל שם מחשב שעליו הסקריפט רץ (שיהיה נעים לעין


foreach ($dnshostname in $computer)

    {
       Write-Host $i .$dnshostname #כותב את שם המחשב שעליו הסקריפט רץ+מספר מהמונה
        
       #התקנה תוכנה ראשונה#       
      
       Copy-Item -Path "\\dc\משותפת\mp3.exe" -Destination "\\$dnshostname\c$\" #העתקה של קובץ ההתקנה מהשרת אל התחנה המרוחקת 

       Invoke-Command -ComputerName $dnshostname -ScriptBlock {Start-Process "c:\mp3.exe" -Wait}  #!הפעלת קובץ ההתקנה-לא לשכוח לשנות שם קובץ 

       $i++ #מונה עולה ב-1
    }
