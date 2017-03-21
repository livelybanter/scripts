$name = $env:COMPUTERNAME
$date = Get-Date

send-mailmessage -from NewSystem@titlemax.com -to tmx.imaging@titlemax.biz -subject "New system online: $name" -BodyAsHtml "System <b> $name </b> has been imaged. $date " -smtpserver prd-excas01