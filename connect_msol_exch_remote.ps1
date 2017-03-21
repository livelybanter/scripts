$cred = Get-Credential "titlemax\admin_mtompkins"
Add-PSSnapin *exchange*
$exch_Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://prd-exmb01.titlemax.com/PowerShell/ -Authentication Kerberos -Credential $cred
Import-PsSession $exch_session -AllowClobber

$online_cred=Get-Credential "admin365@tmxfinanceco.onmicrosoft.com"
$online_session=New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -AllowRedirection -Authentication Basic -Credential $online_cred
Import-PSSession $online_session -prefix 365 -allowclobber

Import-Module ActiveDirectory
Import-Module MSOnline
#Connect-MsolService -cred $online_cred
#Start-Transcript -Path E:\scripts\logs\logs.txt -NoClobber -append
