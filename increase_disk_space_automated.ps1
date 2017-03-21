[decimal]$thresholdspace = 80
#Get-HardDisk -vm $env:computername | where {$_.Name -eq "$disk"} #| Set-HardDisk -CapacityGB $size -ResizeGuestPartition -Confirm:$false
#$OutputEncoding = Get-HardDisk -vm $env:computername | select Name,CapacityGB,Parent

#Get-HardDisk -vm prd-trendcapp01 | where {$_.Name -eq "$"} #| Set-HardDisk -CapacityGB 20 -ResizeGuestPartition -Confirm:$false
#$Out = Get-HardDisk -vm prd-trendcapp01 | select Name,CapacityGB,Parent


$tableFragment= Get-WMIObject -ComputerName $env:computername Win32_LogicalDisk `
| select __SERVER, DriveType, VolumeName, Name, @{n='Size (Gb)' ;e={"{0:n2}" -f ($_.size/1gb)}},@{n='FreeSpace (Gb)';e={"{0:n2}" -f ($_.freespace/1gb)}}, @{n='PercentFree';e={"{0:n2}" -f ($_.freespace/$_.size*100)}} `
| Where-Object {$_.DriveType -eq 3 -and [decimal]$_.PercentFree -lt [decimal]$thresholdspace} `
| ConvertTo-HTML -fragment 

$HTMLmessage = @"
<font color=""black"" face=""Arial, Verdana"" size=""3"">
<u><b>Disk Space Storage Report</b></u>
<br>This report was generated because the drive(s) listed below have less than $thresholdspace % free space. Drives above this threshold will not be listed.
<br>
<style type=""text/css"">body{font: .8em ""Lucida Grande"", Tahoma, Arial, Helvetica, sans-serif;}
ol{margin:0;padding: 0 1.5em;}
table{color:#FFF;background:#C00;border-collapse:collapse;width:647px;border:5px solid #900;}
thead{}
thead th{padding:1em 1em .5em;border-bottom:1px dotted #FFF;font-size:120%;text-align:left;}
thead tr{}
td{padding:.5em 1em;}
tfoot{}
tfoot td{padding-bottom:1.5em;}
tfoot tr{}
#middle{background-color:#900;}
</style>
<body BGCOLOR=""white"">
$tableFragment
</body>
"@ 

$tableFragment
if ($regex.IsMatch($regexsubject)) {
Send-MailMessage -from bleh@titlemax.com -to michael.tompkins@titlemax.com -Subject "here" -BodyAsHtml -body "$HTMLmessage" -SmtpServer prd-excas01.titlemax.com}
#Send-MailMessage -From VMdiskExpanded@titlemax.com -to michael.tompkins@titlemax.biz -Subject "$disk on $env:computername has been increased to $size" -Body $Out -SmtpServer prd-excas01.titlemax.com