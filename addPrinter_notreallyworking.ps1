# Printer Info, I keep this in an SQL DB, and return these values with a query:
$printerID = "CheckPrinter"
$printerIP = "C:\Windows\System32\spool\tools\Microsoft XPS Document Writer"
$printerPort = "XPSPORT:"
$printerModel = "CheckPrinter"
$driverINFPath = "C:\Windows\System32\spool\tools\Microsoft XPS Document Writer\prnms001.inf"

# Build a new Local TCP Printer Port, naming it with values unique to the Printer ID:
$newPort = ([wmiclass]"Win32_TcpIpPrinterPort").CreateInstance()
$newPort.HostAddress = $printerIP
$newPort.Name = $printerPort
$newPort.PortNumber = "XPSPORT:"
$newPort.Protocol = 1
$newPort.Put()

# Add the printer
printui.exe /if /b "$printerID" /f "$driverINFPath" /u /r "$printerPort" /m "$printerModel"