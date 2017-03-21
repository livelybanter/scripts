$scheduledTaskAction = New-ScheduledTaskAction -Execute "c:\tmx_it\TMXPrinterConfigApp\Deploy-Application.exe"
$scheduledTaskTrigger = New-ScheduledTaskTrigger -AtLogOn
$scheduledTaskPrincipal = "$env:computername\Administrator"
$scheduledTaskSettings = New-ScheduledTaskSettingsSet
$scheduledTask = New-ScheduledTask -Action $scheduledTaskAction -Principal $scheduledTaskPrincipal -Trigger $scheduledTaskTrigger -Settings $scheduledTaskSettings
Register-ScheduledTask -TaskName "Printer installation" -InputObject $scheduledTask 
		