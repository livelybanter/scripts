$OU = "OU=StorePCs,OU=WorkstationAccounts,DC=Titlemax,DC=com"
$StateName = Get-ADOrganizationalUnit -searchbase $OU -SearchScope OneLevel -Filter * | Select-Object Name

foreach ($StateName in $OU){
New-ADOrganizationalUnit -name AC -Path "$StateName,$OU"

#New-ADOrganizationalUnit -name AC -Path "OU=$StateName,OU=StorePCs,OU=WorkstationAccounts,DC=Titlemax,DC=com" -PassThru
}