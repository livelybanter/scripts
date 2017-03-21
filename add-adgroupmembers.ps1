<#
$csv = Import-Csv E:\scripts\ddl_allac.csv
foreach ($member in $csv)
{
    Add-adgroupmember -Identity sg-fileaccess-autocash-rw -members $member.Alias
}
#>

#Get-ADGroupMember -Identity "bomgar-admin" | select name #| Add-ADGroupMember -Identity "bomgar-servicedesk" -Members.alias

$Source_Group = "SG-DEPTACCESS-13301"
$Destination_Group = "bomgar-engineering" 
 
$Target = Get-ADGroupMember -Identity $Source_Group -Recursive  
foreach ($Person in $Target) {  
    Add-ADGroupMember -Identity $Destination_Group -Members $Person.distinguishedname  
}  
 