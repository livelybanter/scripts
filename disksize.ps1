$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" |
Select-Object Size,FreeSpace

$disk.Size
$disk.FreeSpace