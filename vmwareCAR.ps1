$cred = Get-Credential "titlemax\admin_mtompkins"
Add-PSSnapin "Vmware.VimAutomation.Core"
Connect-VIServer -server 10.10.144.16 -protocol https -credential $cred
