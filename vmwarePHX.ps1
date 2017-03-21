$cred = Get-Credential "titlemax\admin_mtompkins"
Get-ChildItem -Path 'C:\Program Files (x86)\VMware\Infrastructure\PowerCLI\Modules' -Include *.ps1 -Recurse | select-string -Pattern Add-PSSnapin
Import-Module vmware.vimautomation.core
Connect-VIServer -server 10.2.8.65 -protocol https -credential $cred