#Connect To vSphere
$Credentioal = Get-Credential 
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false
Connect-VIServer -Server SR-IT-08 -Credential $Credentioal

$VM = SR-Rnd-15

get-VM -name $VM | set-VM -MemoryGB 8
get-VM -name $VM | set-VM -NumCpu 4
get-VM -name $VM | set-VM -CoresPerSocket 4