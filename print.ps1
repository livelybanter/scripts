$output = Get-WMIObject Win32_PerfFormattedData_Spooler_PrintQueue | Select Name, @{Expression={$_.jobs};Label="CurrentJobs"}, TotalJobsPrinted, JobErrors | out-string
send-mailmessage -from printreport@titlemax.com -to michael.tompkins@titlemax.biz -subject "Monthly Print Report from PRD-PRNSRV01" -body "$output" -smtpserver prd-excas01

