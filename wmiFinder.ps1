$properties = "name","vendor","version","identifyingnumber"          
Get-WmiObject -Class win32_Product -Property $properties | Where-Object {$_.name -like '*Visio*'} | Select -Property $properties
