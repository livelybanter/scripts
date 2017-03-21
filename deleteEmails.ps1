﻿Get-Mailbox -ResultSize unlimited | where {$_.DisplayName -NotLike "Journal*" -and $_.DisplayName -NotLike "Discovery*"} | Search-Mailbox -SearchQuery {subject:"<subjectlinehere>" AND Received:>05/21/2016 00:00:01 AND Received:<05/21/2016 23:59:00 } -EstimateResultOnly | where {$_.ResultItemsCount -gt 0} | ft DisplayName,ResultItemsCount 

Get-Mailbox -ResultSize unlimited | where {$_.DisplayName -NotLike "Journal*" -and $_.DisplayName -NotLike "Discovery*"} | Search-Mailbox -SearchQuery {subject:"<subjectlinehere>" AND Received:>05/21/2016 00:00:01 AND Received:<05/21/2016 23:59:00 } -DeleteContent -Force | where {$_.ResultItemsCount -gt 0} | ft DisplayName,ResultItemsCount