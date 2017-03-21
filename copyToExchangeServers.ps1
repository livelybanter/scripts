$ExchangeServer = Get-ExchangeServer
ForEach ($server in $ExchangeServer.Name) {

    New-Item -Path "\\$server\c$\scripts" -ItemType directory
    Copy-Item -Path C:\scripts\deleteIIS_exchange\delete_iis_logs.xml -Destination "\\$server\c$\scripts\delete_iis_logs.xml" -Verbose
    Copy-Item -Path C:\scripts\deleteIIS_exchange\deleteIIS.ps1 -Destination "\\$server\c$\scripts\deleteIIS.ps1" -Verbose

    Write-Host "Processing for "$server -ForegroundColor Green
    
    
}