Import-Module ActiveDirectory
$Source_Group = "SG-DEPTACCESS-13301"
$Destination_Group = "bomgar-engineering" 
 
$Target = Get-ADGroupMember -Identity $Source_Group -Recursive  
foreach ($Person in $Target) {  
    Add-ADGroupMember -Identity $Destination_Group -Members $Person.distinguishedname  
}  