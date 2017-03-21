$ddl = Read-Host "Enter name of DDL"
$MEMBERS = Get-DynamicDistributionGroup $ddl 
Get-Recipient -RecipientPreviewFilter $MEMBERS.RecipientFilter -resultsize unlimited | select alias | Export-CSV $psscriptroot\ddl_allac.csv -notype