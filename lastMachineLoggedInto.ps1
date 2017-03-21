$cred = Read-Host "Enter Admin Cred **domain\user**"

Enter-PSSession -ComputerName "prd-sccmapp01.titlemax.com" -Credential $cred | Out-Null
get-eventlog "Security" | where {$_.Message -like "michael.tompkins" -AND "Source Network Address"} | export-csv C:\Temp\test.csv