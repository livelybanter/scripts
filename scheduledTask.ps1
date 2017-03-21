winrm.cmd quickconfig -q
Start-Service -ServiceName winrm
Invoke-Command -ComputerName $env:computername -ScriptBlock {schtasks.exe /Create /tn "merrell's land of pistachios" /RU SYSTEM /tr "C:\windows\System32\shutdown.exe /r /f /d P:4:1 /c 'Scheduled reboot by BOFH'" /sc ONLOGON}
