Option Explicit
On Error Resume Next

Const strComputer = "."
Const ForAppending = 8
Const whichFile = "c:\IT\SophosRemoval"

Const HKEY_CLASSES_ROOT              = &H80000000
Const HKEY_CURRENT_USER              = &H80000001
Const HKEY_LOCAL_MACHINE             = &H80000002
Const HKEY_USERS                     = &H80000003
Const HKEY_CURRENT_CONFIG            = &H80000005

Dim objShell, oShell

If WScript.Arguments.length =0 Then
  Set objShell = CreateObject("Shell.Application")
  Set oShell = CreateObject("WScript.Shell") ' If we're not running as admin (and we're not on XP), re-run as admin
	If CInt(oShell.RegRead("HKLM\software\Microsoft\Windows NT\CurrentVersion\CurrentBuildNumber")) > 3790 Then
			objShell.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " uac", "", "runas", 1
			WScript.Quit
	End If
End If

appLog("**************************************************************************************")
appLog("Welcome to the almighty 'Sophos Smasher'!")
appLog("**************************************************************************************")
appLog("Let's begin, shall we?")
appLog("First, we'll terminate Sophos-related processes...")
killProcs() ' kill all of the Sophos-related processes
appLog("Now, let's shutdown and disable the Sophos-related services...")
shutdownServices() 'shut down all of the Sophos-related services
appLog("Now, we'll take another whack at the Sophos-related processes...")
killProcs() ' kill all of the Sophos-related processes
appLog("Next, we will run the uninstallers for each of the Sophos applications...")
removeSoftware() ' remove all of the Sophos-software
appLog("One more attack on the Sophos-related processes...")
killProcs() ' kill all of the Sophos-related processes
appLog("Then, we'll delete any remaining Sophos-related files...")
delFiles() ' delete all of the Sophos-related files/folders
appLog("Cleaning up the registry...")
cleanRegistry() ' delete all of the Sophos-related registry keys
appLog("Script finished...")

' Recursively removes the given registry key
Sub delRegKey(ByVal sHive, ByVal sKey)
	On Error Resume next
	Dim aSubKeys, sSubKey, iRC, strComputer, oReg
	strComputer = "."
	Set oReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\default:StdRegProv")
	iRC = oReg.EnumKey(sHive, sKey, aSubKeys)
	If iRC = 0 And IsArray(aSubKeys) Then
		For Each sSubKey In aSubKeys
			delRegKey sHive, sKey & "\" & sSubKey
		Next
	End If
	oReg.DeleteKey sHive, sKey
End Sub

' Shuts down the Sophos services
Sub shutdownServices()
	On Error Resume next
	Dim objWMIService, colListOfServices, objService, tmpString
	appLog("Loading up services to shut down and disable...")
	Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	Set colListOfServices = objWMIService.ExecQuery("Select * from Win32_Service Where Name ='SAVService'" & _
	" or Name = 'SAVAdminService'" & _
	" or Name = 'Sophos AutoUpdate Service'" & _
	" or Name = 'Sophos Web Control Service'" & _
	" or Name = 'Sophos Agent'" & _
	" or Name = 'Sophos Client Firewall'" & _
	" or Name = 'Sophos Web Intelligence Update'" & _
	" or Name = 'Sophos Client Firewall Manager'" & _
	" or Name = 'Sophos Compliance Agent API'" & _
	" or Name = 'Sophos Message Router'" & _
	" or Name = 'swi_service'" & _
	" or Name = 'swi_update'" & _
" or Name = 'sntpService'" & _
" or Name = 'sophossps'" & _
	" or Name = 'swi_update_64'")
	For Each objService in colListOfServices
		appLog("	Stopping service: " & objService.Name)
		objService.StopService()
		appLog("	Disabling service: " & objService.Name)
		removeService(objService.Name)
		appLog("	Removing service: " & objService.Name)
		objService.Delete()
	Next
End Sub

' Removes a service
' "svcName" is a string, name of the service to disable
Sub removeService(svcName)
	On Error Resume next
	Dim strComputer, objRegistry, strKeyPath
	strComputer = "."
	Set objRegistry = GetObject("winmgmts:\\" & strComputer & "\root\default:StdRegProv")
 	strKeyPath = "\SYSTEM\ControlSet001\services\" & svcName
	delRegKey HKEY_LOCAL_MACHINE,strKeyPath
 	strKeyPath = "\SYSTEM\ControlSet002\services\" & svcName
	delRegKey HKEY_LOCAL_MACHINE,strKeyPath
 	strKeyPath = "\SYSTEM\CurrentControlSet\services\" & svcName
	delRegKey HKEY_LOCAL_MACHINE,strKeyPath
End Sub


Sub killProcs() ' Terminates known Sophos processes

	On Error Resume next

	Dim objWMIService, colProcessList, objProcess

	appLog("Loading up processes to terminate...")
	Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	Set colProcessList = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name = 'backgroundscanclient.exe'" & _
		" or Name = 'sav32cli.exe'" & _
		" or Name = 'savadminservice.exe'" & _
		" or Name = 'savcleanupservice.exe'" & _
		" or Name = 'savmain.exe'" & _
		" or Name = 'savprogress.exe'" & _
		" or Name = 'savproxy.exe'" & _
		" or Name = 'savservice.exe'" & _
		" or Name = 'sdcdevcon.exe'" & _
		" or Name = 'sdcservice.exe'" & _
		" or Name = 'wscclient.exe'" & _
		" or Name = 'clientmrinit.exe'" & _
		" or Name = 'emlibupdateagentnt.exe'" & _
		" or Name = 'almon.exe'" & _
		" or Name = 'agentapi.exe'" & _
		" or Name = 'alsvc.exe'" & _
		" or Name = 'alupdate.exe'" & _
		" or Name = 'autoupdateagentnt.exe'" & _
		" or Name = 'agentasst.exe'" & _
		" or Name = 'managementagentnt.exe'" & _
		" or Name = 'routernt.exe'" & _
		" or Name = 'alupdate.exe'" & _
		" or Name = 'SavService.exe'" & _
		" or Name = 'swc_service.exe'" & _
		" or Name = 'swi_service.exe'" & _
" or Name = 'ssp.exe'" & _
		" or Name = 'scfmanager.exe'")

	For Each objProcess in colProcessList
		appLog("	Terminating process: " & objProcess.Name)
		objProcess.Terminate()
	Next

End Sub

Sub removeSoftware() ' Runs the uninstallers for the Sophos Software

	On Error Resume next

	Dim oShell, UninstallString, arch

	arch = getArch()
	Set oShell = CreateObject("WScript.Shell")

	appLog("	Running firewall uninstaller")
	UninstallString = "MsiExec.exe /X{12C00299-B8B4-40D3-9663-66ABEA3198AB} /qn /norestart" ' Remove Sophos Firewall
	oShell.Run UninstallString, 1, True

	appLog("	Running AV uninstaller")
	UninstallString = "MsiExec.exe /X{9ACB414D-9347-40B6-A453-5EFB2DB59DFA} /qn /norestart" ' Remove Sophos Anti-Virus
	oShell.Run UninstallString, 1, True

	appLog("	Running AV uninstaller")
	UninstallString = "MsiExec.exe /X{09863DA9-7A9B-4430-9561-E04D178D7017} /qn /norestart" ' Remove Sophos Anti-Virus
	oShell.Run UninstallString, 1, True

	appLog("	Running Auto-Update uninstaller")
	UninstallString = "MsiExec.exe /X{15C418EB-7675-42be-B2B3-281952DA014D} /qn /norestart" ' Remove Sophos Auto-Update
	oShell.Run UninstallString, 1, True

	appLog("	Running Auto-Update uninstaller")
	UninstallString = "MsiExec.exe /X{BCF53039-A7FC-4C79-A3E3-437AE28FD918} /qn /norestart" ' Remove Sophos Auto-Update
	oShell.Run UninstallString, 1, True


	If arch = 64 Then
		appLog("	Running Compliance Agent (64-bit) uninstaller")
		UninstallString = "MsiExec.exe /X{8bcff7e3-e241-4230-bb5d-a6676e840f65} /qn /norestart" ' Remove Sophos Compliance Agent x64
		oShell.Run UninstallString, 1, True

	Else
		appLog("	Running Compliance Agent (32-bit) uninstaller")
		UninstallString = "MsiExec.exe /X{486feabf-70eb-48c1-9c35-700b74a8ebe6} /qn /norestart" ' Remove Sophos Compliance Agent
		oShell.Run UninstallString, 1, True
	End If

	appLog("	Running Remote Management System uninstaller")
	UninstallString = "MsiExec.exe /X{FED1005D-CBC8-45D5-A288-FFC7BB304121} /qn /norestart" ' Remove Sophos Remote Management System
	oShell.Run UninstallString, 1, True

	appLog("	Running Network Threat Protection Uninstaller")
	UninstallString = "MsiExec.exe /X{66967E5F-43E8-4402-87A4-04685EE5C2CB} /qn /norestart" ' Remove Sophos Network Threat
	oShell.Run UninstallString, 1, True

	appLog("	Running System Protection Uninstaller")
	UninstallString = "MsiExec.exe /X{1093B57D-A613-47F3-90CF-0FD5C5DCFFE6} /qn /norestart" ' Remove System Protection
	oShell.Run UninstallString, 1, True

End Sub

Sub delFiles() ' Recursively remove any extra files or directories that might still be around

	On Error Resume next
	Dim fso, wshShell, targetDir, AU, RM, SAV, delFile, delFolder, toRemove, arch

	appLog("Loading up files to delete...")
	Set fso = CreateObject("scripting.FileSystemObject")
	Set wshShell = CreateObject( "WScript.Shell" )

	targetDir = wshShell.ExpandEnvironmentStrings( "%ProgramFiles%" )

	arch = getArch()

	If arch = 64 Then ' If we're on a 64-bit machine, do this one instead
		targetDir = wshShell.ExpandEnvironmentStrings( "%ProgramFiles(x86)%" )
	Else
		targetDir = wshShell.ExpandEnvironmentStrings( "%ProgramFiles%" )
	End If

	AU = targetDir & "\Sophos\AutoUpdate"
	RM = targetDir & "\Sophos\Remote Management System"
	SAV = targetDir & "\Sophos\Sophos Anti-Virus"

	toRemove = Array(AU & "\ALMon.exe",_
		AU & "\ALsvc.exe",_
	    AU & "\ALUpdate.exe",_
	    RM & "\AutoUpdateAgentNT.exe",_
	    RM & "\ClientMRInit.exe",_
	    RM & "\EMLibUpdateAgentNT.exe",_
	    RM & "\ManagementAgentNT.exe",_
	    RM & "\RouterNT.exe",_
	    SAV & "\BackgroundScanClient.exe",_
	    SAV & "\native.exe",_
	    SAV & "\sav32cli.exe",_
	    SAV & "\SAVAdminService.exe",_
	    SAV & "\SAVCleanupService.exe",_
	    SAV & "\SavMain.exe",_
	    SAV & "\SavProgress.exe",_
	    SAV & "\SavProxy.exe",_
	    SAV & "\SavService.exe",_
	    SAV & "\sdcdevcon.exe",_
	    SAV & "\sdcservice.exe",_
	    SAV & "\WSCClient.exe",_
	    "C:\WINDOWS\system32\Drivers\QtineFtr.sys",_
	    "C:\WINDOWS\system32\Drivers\savonaccess.sys",_
	    "C:\WINDOWS\system32\Drivers\sdcfilter.sys",_
	    "C:\WINDOWS\system32\Drivers\SophosBootDriver.sys",_
	    "C:\Windows\System32\SophosBootTasks.exe",_
	    "C:\WINDOWS\LastGood\system32\DRIVERS\SophosBootDriver.sys",_
	    SAV & "\DataControlPlugin.dll",_
	    SAV & "\ThreatDetection.dll",_
	    SAV & "\ThreatManagement.dll",_
	    SAV & "\ICAdapter.dll",_
	    SAV & "\ICProcessors.dll",_
	    SAV & "\Web Control\WebControlPlugin.dll",_
	    SAV & "\FSDecomposer.dll",_
	    SAV & "\SIPSManagement.dll",_
	    SAV & "\TamperProtectionPlugin.dll",_
	    SAV & "\SavRes.dll",_
	    "C:\Documents and Settings\All Users\Application Data\Sophos\Web Intelligence\swi_update.exe"_
	)

	For Each delFile in toRemove
		appLog("	Deleting File: " & delFile)
		If fso.FileExists(delFile) Then fso.DeleteFile delFile,True
	Next

	delFolder = wshShell.ExpandEnvironmentStrings( "%APPDATA%" ) & "\Local\Sophos"
	appLog("	Recursively Removing Folder: " & delFolder)
	If fso.FolderExists(delFolder) Then ProcessSubFolders(fso.GetFolder(delFolder))
	If fso.FolderExists(delFolder) Then fso.DeleteFolder delFolder, True

	delFolder = targetDir & "\Sophos"
	appLog("	Recursively Removing Folder: " & delFolder)
	If fso.FolderExists(delFolder) Then ProcessSubFolders(fso.GetFolder(delFolder))
	If fso.FolderExists(delFolder) Then fso.DeleteFolder delFolder, True

	delFolder = "C:\Documents and Settings\All Users\Application Data\Sophos"
	appLog("	Recursively Removing Folder: " & delFolder)
	If fso.FolderExists(delFolder) Then ProcessSubFolders(fso.GetFolder(delFolder))
	If fso.FolderExists(delFolder) Then fso.DeleteFolder delFolder, True

	delFolder = "C:\Windows\Installer\{9ACB414D-9347-40B6-A453-5EFB2DB59DFA}"
	appLog("	Recursively Removing Folder: " & delFolder)
	If fso.FolderExists(delFolder) Then ProcessSubFolders(fso.GetFolder(delFolder))
	If fso.FolderExists(delFolder) Then fso.DeleteFolder delFolder, True

	delFolder = "C:\ProgramData\Sophos"
	appLog("	Recursively Removing Folder: " & delFolder)
	If fso.FolderExists(delFolder) Then ProcessSubFolders(fso.GetFolder(delFolder))
	If fso.FolderExists(delFolder) Then fso.DeleteFolder delFolder, True

	delFolder = "C:\escw_102_sa"
	appLog("	Recursively Removing Folder: " & delFolder)
	If fso.FolderExists(delFolder) Then ProcessSubFolders(fso.GetFolder(delFolder))
	If fso.FolderExists(delFolder) Then fso.DeleteFolder delFolder, True

	If arch = 64 Then
		delFolder = "C:\Users\All Users\Sophos"
	Else
		delFolder = "C:\Documents and Settings\All Users\Application Data\Sophos"
	End If
	appLog("	Recursively Removing Folder: " & delFolder)
	If fso.FolderExists(delFolder) Then ProcessSubFolders(fso.GetFolder(delFolder))
	If fso.FolderExists(delFolder) Then fso.DeleteFolder delFolder, True

	delFolder = "C:\Windows\Temp"
	appLog("	Recursively Removing Folder: " & delFolder)
	If fso.FolderExists(delFolder) Then ProcessSubFolders(fso.GetFolder(delFolder))

	If arch = 64 Then
		delFolder = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Sophos"
	Else
		delFolder = "C:\Documents and Settings\All Users\Start Menu\Programs\Sophos"
	End If
	appLog("	Recursively Removing Folder: " & delFolder)
	If fso.FolderExists(delFolder) Then ProcessSubFolders(fso.GetFolder(delFolder))
	If fso.FolderExists(delFolder) Then fso.DeleteFolder delFolder, True

End Sub

Sub ProcessSubFolders(oFolder) ' Recursively delete all contents and subfolders of a folder
	On Error Resume next
	Dim cFiles, oFile, oSubFolder
	Set cFiles = oFolder.Files
	For Each oFile In cFiles
		oFile.Delete True
	Next
	For Each oSubFolder In oFolder.SubFolders
		ProcessSubFolders oSubFolder
	Next
End Sub

Function getArch() ' Are we on a 32-bit system or a 64-bit system?
	On Error Resume Next
	Dim objShell  : Set objShell = CreateObject("Wscript.Shell")
	Dim objFSO    : Set objFSO   = WScript.CreateObject("Scripting.FileSystemObject")
	Dim strWindir : strWinDir    = objShell.ExpandEnvironmentStrings("%WinDir%")
	If objFSO.FolderExists(strWindir & "\syswow64") Then
	   getArch = 64
	    else
	   getArch = 32
	End If
End Function


' subroutine to write text out to a file
' 'whichFile' is a Const
Sub appLog(toWrite)

	On Error Resume next
	Dim objFSO, objTextFile, dateTime

	Set objFSO = CreateObject("Scripting.FileSystemObject")
	Set dateTime = CreateObject("WbemScripting.SWbemDateTime")

	Set objTextFile = objFSO.OpenTextFile (whichFile, ForAppending, True)
	objTextFile.WriteLine(Now & ": " & toWrite)
	objTextFile.Close

End Sub

Sub cleanRegistry() ' Clean all of the crap out of the registry
	On Error Resume Next

	Dim arch

	arch = getArch()
	delRegKey HKEY_LOCAL_MACHINE, "SOFTWARE\Classes\Installer\Products\D414BCA974396B044A35E5BFD25BD9AF"
	delRegKey HKEY_LOCAL_MACHINE, "SOFTWARE\Sophos"
	delRegKey HKEY_LOCAL_MACHINE, "SOFTWARE\Sophos Temp"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\Services\swi_update"
	delRegKey HKEY_CLASSES_ROOT, "Installer\Products\BE814C515767eb242B3B829125AD10D4"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\Control\SafeBoot\Network\Sophos Client Firewall"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\Control\SafeBoot\Network\Sophos Client Firewall Manager"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\Control\SafeBoot\Network\SAVService"
	delRegKey HKEY_CLASSES_ROOT, "Installer\Products\D414BCA974396B044A35E5BFD25BD9AF"
	delRegKey HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{8bcff7e3-e241-4230-bb5d-a6676e840f65}"
	delRegKey HKEY_LOCAL_MACHINE, "SOFTWARE\Classes\Installer\Products\D414BCA974396B044A35E5BFD25BD9AF"
	delRegKey HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{8bcff7e3-e241-4230-bb5d-a6676e840f65}"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\services\QtineFtr"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\services\SAVAdminService"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\services\SAVService"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\services\SAVOnAccess"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\services\sdcfilter"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\services\Sophos Web Control Service"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\services\Sophos Web Intelligence Update"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\services\SophosBootDriver"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\services\swi_service"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\services\swi_update"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet002\services\QtineFtr"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet002\services\SAVAdminService"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet002\services\SAVService"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet002\services\SAVOnAccess"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet002\services\sdcfilter"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet002\services\Sophos Web Control Service"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet002\services\Sophos Web Intelligence Update"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet002\services\SophosBootDriver"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet002\services\swi_service"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet002\services\swi_update"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet003\services\QtineFtr"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet003\services\SAVAdminService"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet003\services\SAVService"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet003\services\SAVOnAccess"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet003\services\sdcfilter"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet003\services\Sophos Web Control Service"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet003\services\SophosBootDriver"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet003\services\swi_service"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet003\services\swi_update"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\services\QtineFtr"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\services\SAVAdminService"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\services\SAVOnAccess"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\services\SAVService"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\services\sdcfilter"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\services\Sophos Web Control Service"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\services\Sophos Web Intelligence Update"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\services\SophosBootDriver"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\services\swi_update"
	delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\services\swi_service"
	delRegKey HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9ACB414D-9347-40B6-A453-5EFB2DB59DFA}"

	If arch = 64 Then 'if 64-bit, then do these, too
		delRegKey HKEY_LOCAL_MACHINE, "SOFTWARE\Classes\Wow6432Node\AppID\{752B5BD1-9128-47B7-9934-E6DE5C5397D0}"
		delRegKey HKEY_LOCAL_MACHINE, "SOFTWARE\Classes\Wow6432Node\CLSID\{00920966-F6E8-461a-BF85-5F3AF429AC7F}"
		delRegKey HKEY_LOCAL_MACHINE, "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{15C418EB-7675-42BE-B2B3-281952DA014D}"
		delRegKey HKEY_LOCAL_MACHINE, "SOFTWARE\Wow6432Node\Sophos"
		delRegKey HKEY_LOCAL_MACHINE, "SOFTWARE\Wow6432Node\Microsoft\Security Center\Monitoring\SophosAntiVirus"
		delRegKey HKEY_LOCAL_MACHINE, "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{9ACB414D-9347-40B6-A453-5EFB2DB59DFA}"
		delRegKey HKEY_LOCAL_MACHINE, "SOFTWARE\Wow6432Node\Sophos Temp"
		delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet001\services\swi_update_64"
		delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet002\services\swi_update_64"
		delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\ControlSet003\services\swi_update_64"
		delRegKey HKEY_LOCAL_MACHINE, "SYSTEM\CurrentControlSet\services\swi_update_64"
	End If

End Sub
