$Database = Read-Host -Prompt 'What Database are you moving the Primary to?'
$ArchiveDatabase = Read-Host -Prompt 'What Database are you moving the Archive to?'


If ($IsPrimary -eq 'Y' -and $IsArchive -eq 'Y')
	{ 
		New-MoveRequest $Mailbox -TargetDatabase $Database -ArchiveTargetDatabase $ArchiveDatabase
	} 
