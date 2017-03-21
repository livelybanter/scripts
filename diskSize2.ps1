﻿$output = get-psdrive C | select Root, @{Name="Used GB";Expression={[math]::round($_.used/1gb,2)}}, @{Name="Free GB";Expression={[math]::round($_.free/1gb,2)}}, @{Name="% Free";expression={$_.free/($_.free+$_.used)*100 –as [int]}} | out-string
send-mailmessage -from PRD-TRENDCAPP01@titlemax.com -to michael.tompkins@titlemax.biz -subject "Disk Report for PRD-TRENDCAPP01" -body "$output" -smtpserver prd-excas01
