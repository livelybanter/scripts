$User = read-host -Prompt "Enter User" 

$User + " is a member of these groups:" 

ForEach ($Group in Get-DistributionGroup) 
{ 
   ForEach ($Member in Get-DistributionGroupMember -identity $Group | Where { $_.Name –eq $User }) 
   { 
      $Group.name 
   } 
}