$usersInCollection = Get-CMDevice -CollectionName 'test systems | michael t' | select username | Out-File e:\scripts\users.txt
$email = "@titlemax.com"
$Text = [io.file]::ReadAllText("e:\scripts\users.txt.")
$join = -join ($Text, $email)

foreach ($user in $text){
#$email = get-aduser -identity -join ($usersInCollection, $email) | select userprincipalname
send-mailmessage -from updatenow@titlemax.com -to $join -subject "update" -body "update now" -smtpserver prd-excas01
}