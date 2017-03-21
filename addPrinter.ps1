$printerclass = [wmiclass]'Win32_Printer';
$printer = $printerclass.CreateInstance();
$printer.Name = $printer.DeviceID = 'Microsoft XPS Document Writer';
$printer.PortName = 'XPSPort:';
$printer.Network = $false;
$printer.Shared = $false;
$printer.DriverName = 'Microsoft XPS Document Writer';
$printer.Put()

test
