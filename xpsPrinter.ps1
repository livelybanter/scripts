$printerclass = [wmiclass]’Win32_Printer’
$printer = $printerclass.CreateInstance()
$printer.Name = $printer.DeviceID = ‘FormsPrinter’
$printer.PortName = ‘XPSPort:’
$printer.Network = $false
$printer.Shared = $false
$printer.DriverName = ‘Microsoft XPS Document Writer’
$printer.Put()


$printerclass2 = [wmiclass]’Win32_Printer’
$printer2 = $printerclass2.CreateInstance()
$printer2.Name = $printer2.DeviceID = ‘CheckPrinter’
$printer2.PortName = ‘XPSPort:’
$printer2.Network = $false
$printer2.Shared = $false
$printer2.DriverName = ‘Microsoft XPS Document Writer’
$printer2.Put()

(Get-WmiObject -ComputerName . -Class Win32_Printer -Filter "Name='FormsPrinter'").SetDefaultPrinter()
