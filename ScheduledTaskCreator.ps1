# As long as you've stored both .ps1 files in the same folder, this automatically fetches the correct path to create the Schedueld Task
$thisFilePath = Split-Path $MyInvocation.MyCommand.Path -Parent
$scriptFilePath = $thisFilePath + "\SpotlightCopier.ps1"
$scriptFilePathQuoted = """$($scriptFilePath)"""

# Set all the variables needed for Windows Scheduled Task creation
$userid = (Get-CimInstance -ClassName Win32_ComputerSystem).Username
$description = "Copy images out of the Windows Spotlight folder at logon"
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-file $($scriptFilePathQuoted)"
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $userid
$principal = New-ScheduledTaskPrincipal -UserId $userid -LogonType Interactive
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopOnIdleEnd -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Hours 1)
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings -Description $description

# Create the task
Register-ScheduledTask "Copy Windows Spotlight Images" -InputObject $task