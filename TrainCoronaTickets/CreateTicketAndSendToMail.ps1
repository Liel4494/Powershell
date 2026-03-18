##############
# יצירת קוד QR #
##############


$Date = Get-Date -Format "MM/dd/yyyy"
$Month = $Date.Substring(0,2)
$Day=$Date.Substring(3,2)
$Year=$Date.Substring(6,4)
$Ticketdate = $year+$Month+$Day 


$Time = Get-Date -Format "HH:mm"
$Hour = $Time.Substring(0,2)
$Minutes = $Time.Substring(3,2)
$TicketTime = $Hour+$Minutes
 

 
 $ToWorkTicket = $Ticketdate+'0717'+'965'+'000'+'610'+'000'+'058'
 $ToHomeTicket = $Ticketdate+'1833'+'370'+'000'+'653'+'000'+'058'

 <#
 שעה     תאריך   שנה	    קוד-תחנה	 מפריד 	  מספר-רכבת     	        מפריד	מספר רץ
2020	0916	0717	 965	     000        	610           000               058
#>

$QrDate = $Day+"-"+$Month+"-"+$Year
$QRTime = $Ticketdate+$TicketTime

Invoke-WebRequest "http://api.qrserver.com/v1/create-qr-code/?data=$ToWorkTicket&size=100x100" -OutFile C:\Path Here\'ToWork'+$QrDate+$QRTime.png
Invoke-WebRequest "http://api.qrserver.com/v1/create-qr-code/?data=$ToHomeTicket&size=100x100" -OutFile C:\Path Here\'ToHome'+$QrDate+$QRTime.png






##############
# שליחת מיילים #
##############
#הלוך#

$Username = "User Name Here";
$Password = "Password Here";
$path = "C:\Path Here\ToWork+$QrDate+$QRTime.png";

function Send-ToEmail([string]$email, [string]$attachmentpath){

    $message = new-object Net.Mail.MailMessage;
    $message.From = "username@gmail.com";
    $message.To.Add($email);
    $message.Subject = "Train Ticket-TO Work $QrDate";
    $message.Body = "$notsmartuser";
    $attachment = New-Object Net.Mail.Attachment($attachmentpath);
    $message.Attachments.Add($attachment);

    $smtp = new-object Net.Mail.SmtpClient("smtp.gmail.com", "587");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
    write-host "Mail Sent" ; 
    $attachment.Dispose();
 }
Send-ToEmail  -email "TargetMail@gmail.com" -attachmentpath $path;



#חזור#

$Username ="User Name Here";
$Password = "Password Here";
$path = "C:\Path Here\ToHome+$QrDate+$QRTime.png";


function Send-ToEmail([string]$email, [string]$attachmentpath){

    $message = new-object Net.Mail.MailMessage;
    $message.From = "username@gmail.com";
    $message.To.Add($email);
    $message.Subject = "Train Ticket-TO Home $QrDate";
    $message.Body = "$notsmartuser";
    $attachment = New-Object Net.Mail.Attachment($attachmentpath);
    $message.Attachments.Add($attachment);

    $smtp = new-object Net.Mail.SmtpClient("smtp.gmail.com", "587");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
    $smtp.send($message);
    write-host "Mail Sent" ; 
    $attachment.Dispose();
 }
Send-ToEmail  -email "TargetMail@gmail.com" -attachmentpath $path;



Remove-Item -Path C:\Path Here\ToWork+$QrDate+$QRTime.png -Force
Remove-Item -Path C:\Path Here\ToHome+$QrDate+$QRTime.png -Force 
