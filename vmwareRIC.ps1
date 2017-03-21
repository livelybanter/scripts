$cred = Get-Credential "titlemax\admin_mtompkins"
Add-PSSnapin "Vmware.VimAutomation.Core"
Connect-VIServer -server 10.1.8.65 -protocol https -credential $cred 
