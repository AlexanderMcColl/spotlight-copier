<#
Add-Type -AssemblyName System.Windows.Forms
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    InitialDirectory = [Environment]::GetFolderPath('Desktop')
    Filter           = '*.ps1'
}
$Null = $FileBrowser.ShowDialog()

Write-Host $FileBrowser.FileName.Value
#>

$scriptFilePath = '"D:\Dev\Windows wallpaper copier (PS)\SpotlightCopier.ps1"'
$userid = (Get-CimInstance -ClassName Win32_ComputerSystem).Username

$description = "Copy images out of the Windows Spotlight folder after logon after computer has been idle for 5 seconds"
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-file $($scriptFilePath)"
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $userid
$principal = New-ScheduledTaskPrincipal -UserId $userid -LogonType Interactive
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopOnIdleEnd -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Hours 1)
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings -Description $description
Register-ScheduledTask "Copy Windows Spotlight Images" -InputObject $task