Get-ADUser -Filter {UserPrincipalName -like "*@domain.local.net"} -SearchBase "OU=Users,OU=Dept,DC=domain,DC=local,DC=net" | 
ForEach-Object { 
    Write-Host $_.Name 
    $UPN = $_.UserPrincipalName.Replace("domain.local.net","newdomain.com") 
    Set-ADUser $_ -UserPrincipalName $UPN 
}