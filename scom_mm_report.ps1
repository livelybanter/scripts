#Start-Transcript -Path c:\scripts\logs.txt -NoClobber -append
Import-Module operationsmanager

$ReportOutput =
“<h2>Computers in Maintenance Mode</h2>”

$mc = get-scomClass | where {$_.name -like "Microsoft.Windows.Computer" -or $_.name -like "Microsoft.Linux.Computer"}

$mo = Get-SCOMClassInstance  $mc | Where {$_.InMaintenanceMode -eq ‘True’}

$mv = $mo | measure


if($mv.Count -gt 0)

{

    foreach ($Mo in $Mo)

{ 

                        $ReportOutput += “<h3>$mo</h3>”

                        $ReportOutput += $mo | get-scommaintenancemode | Select StartTime,ScheduledEndTime,EndTime,Reason,Comments,User | ConvertTo-HTML

}

 

} else {

$ReportOutput +=”<h4>No Servers are in Maintenance Mode</h4>”

}

Send-MailMessage -From MaintenanceModeReport@titlemax.com -to michael.tompkins@titlemax.biz -SmtpServer prd-excas01.titlemax.com -Subject "Servers in Maintenance Mode" -BodyAsHtml $ReportOutput
