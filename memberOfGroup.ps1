Import-Module activedirectory

$User = read-host -Prompt "Enter User" 
$Groups = $(Get-ADUser $User -Properties memberOf).memberOf

Foreach ($Group in $Groups) {
Get-ADGroup $Group | select distinguishedname,groupcategory,name #| ft
}