# Specify the maximum log age file to maintain
$MaxDays = 1

function DiscoverIISLogs ($MaxDays)
{
	try
	{
		# Import IIS WebAdmin Module
		Import-Module WebAdministration
		
		# Return list of IIS webistes
		$IISSites = Get-Website
		# Loop for each IIS site
		foreach ($Site in $IISSites)
		{
			# Return path for IIS logs
			$IISLogs = $Site.LogFile.Directory
			# Condition to replace DOS %SystemDrive% variable with Powershell variable
			If ($IISLogs -like "*%SystemDrive%*")
			{
				$IISLogs = $IISLogs -replace "%SystemDrive%", "$env:SystemDrive"
			}
			# Count IIS Log files to prune
			$LogCount = $LogCount + (Get-ChildItem -Path $IISLogs -Recurse -Filter "*.log" | Where-Object { $(Get-Date).Subtract($_.LastWriteTime).Days -gt $MaxDays}).count
		}
		Return $LogCount
	}
	catch { return -1 }
}

DiscoverIISLogs ($MaxDays)

function PurgeIISLogs ($MaxDays)
{
	try
	{
		# Import IIS WebAdmin Module
		Import-Module WebAdministration
		
		# Return list of IIS webistes
		$IISSites = Get-Website
		# Loop for each IIS site
		foreach ($Site in $IISSites)
		{
			# Return path for IIS logs
			$IISLogs = $Site.LogFile.Directory
			# Condition to replace DOS %SystemDrive% variable with Powershell variable
			If ($IISLogs -like "*%SystemDrive%*")
			{
				$IISLogs = $IISLogs -replace "%SystemDrive%", "$env:SystemDrive"
			}
			# Purge IIS Log files
			Get-ChildItem -Path $IISLogs -Recurse -Filter "*.log" | Where-Object { $(Get-Date).Subtract($_.LastWriteTime).Days -gt $MaxDays } | Foreach-Object { Remove-Item $_.FullName -Force -Verbose }
		}
	}

catch {  }
}

PurgeIISLogs ($MaxDays)