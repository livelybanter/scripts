Import-Module dhcpserver

$scopeold = '10.176.26.0'
$scope = '10.193.246.0'
$scope65 = '10.193.246.64'

#SetDHCPServer to Run against
$server = 'prd-windhcp03'
$serverold = "nor-dhcp-01"

write-host "old scope information"
$scopeold
Get-DhcpServerv4Lease -computername $serverold -scopeid $scopeold -AllLeases | ft

write-host "new scope information"
$scope
Get-DhcpServerv4Lease -computername $server -scopeid $scope -AllLeases | ft

#write-host "new scope information .65"
#$scope65
#get-dhcpserverv4lease -ComputerName $server -ScopeId $scope65 -AllLeases | ft