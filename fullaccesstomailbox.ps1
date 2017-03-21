#Granting a user Full Access to a mailbox

#Prompt for user who is getting Full Access
$User = Read-Host -Prompt 'Who is user receiving Full Access?'

#Prompt for object that user is getting Full Access to
$Object = Read-Host -Prompt 'What object is user receiving Full Access to?'

$UserInfo = Get-ADUser $Object -Properties Displayname
$ADUser = $UserInfo.Displayname

#Prompt asking if user needs Send As or Send on Behalf
$Send = Read-Host -Prompt 'Does user require any of the following? Type Send As, Send on Behalf or None'



						 
If($Send -eq "Send As")
	{
		Add-MailboxPermission -Identity $Object -User $User -AccessRights FullAccess -InheritanceType All
		Add-ADPermission -Identity $ADUser -User $User -ExtendedRights "Send As"
	}
	
ElseIf($Send -eq "Send on Behalf")
	{
		Add-MailboxPermission -Identity $Object -User $User -AccessRights FullAccess -InheritanceType All
		Set-Mailbox $Object -GrantSendOnBehalfTo @{add=$User}
	}
	
ElseIf($Send -eq "None")
	{
		Add-MailboxPermission -Identity $Object -User $User -AccessRights FullAccess -InheritanceType All
	} 
