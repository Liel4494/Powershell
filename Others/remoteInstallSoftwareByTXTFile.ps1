# 1. Winrm quickconfig -quiet :קודם כל לעשות על כל מחשב את הפקודה הזאת
# 2. firewall-ב Windows Remote Management את החוק gpo לפתוח באמצעות
# 3. c$-להפעיל גילוי ברשת כדי שתהיה גישה ב 
# 4. לא לשכוח לעשות קבצי התקנה אוטומטיים
# 5. :צריך להיראות כך csv-קובץ ה:
#     computer -חשוב
#     computer1
#     computer2
# וכן הלאה

$computer =  Import-Csv C:\list.csv #יבוא של שמות המחשבים שברצוננו להתקין עליהם את התוכנות 

$i = 1 #(מוסיף מספר ליד כל שם מחשב שעליו הסקריפט רץ (שיהיה נעים לעין

foreach ($computer in $computer)

 {
   
    Write-Host $i. $_.computer

    #התקנה תוכנה ראשונה#

	Copy-Item -Path "\\server2012\Classes\ליאל\Auto\SignVerify Software.exe" -Destination "\\$_.computer\c$\" #העתקת ההתקנה מהתיקיה המשותפת לתחנה המרוחקת

	Invoke-Command -ComputerName $_.computer -Credential 660134mb\administrator -ScriptBlock {Start-Process "c:\SignVerify Software.exe" -Wait} #!הפעלת קובץ ההתקנה-לא לשכוח לשנות שם קובץ
 }
 
