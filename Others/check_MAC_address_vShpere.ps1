$Credentioal = Get-Credential 
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Connect-VIServer -Server SR-IT-08 -Credential $Credentioal
New-NetworkAdapter -VM Sr-RnD-15 -Portgroup PortGroupName