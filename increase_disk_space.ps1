$vm = Read-Host "which vm?"
$disk = read-host "which disk do you want to extend?"
$size = read-host "how big should the disk be? (GB)"

write-host "list of disks on $vm" -ForegroundColor Yellow
Get-HardDisk -vm $vm | select Name,CapacityGB,Parent


Get-HardDisk -vm $vm | where {$_.Name -eq "$disk"} | Set-HardDisk -CapacityGB $size -ResizeGuestPartition -Confirm:$false -whatif

Send-MailMessage -From VMdiskExpanded@titlemax.com -to michael.tompkins@titlemax.biz -Subject "$disk on $vm has been increased to $size" -SmtpServer prd-excas01.titlemax.com

Get-HardDisk -vm prd-trendcapp01 {$_.Name -eq "new volume"} | Set-HardDisk -CapacityGB 2 -ResizeGuestPartition -Confirm:$false -WhatIf