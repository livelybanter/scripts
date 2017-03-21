#Get-Content to pull in all the DBs for that server
$content = Get-Content "c:\scripts\archiveDB.txt"
#Does a foreach loop to get the list of mailboxes with archives on those specific DBs and puts the results into a variable
$u = foreach($user in $content) {Get-Mailbox -ResultSize unlimited |?{$_.ArchiveDatabase -eq "$user"}|select userprincipalname, database, archivedatabase}
#Exports results of variable into CSV
$u|Export-csv "C:\scripts\archiveDB_prd-xmbsarc02.csv" 