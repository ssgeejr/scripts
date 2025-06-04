
# Restore Microsoft Edge AutoLaunch Registry Key
$runKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$autoLaunchName = "MicrosoftEdgeAutoLaunch_A54D2A9DA7FDD31741088B87F2F851A7"
$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$edgeArgs = "--no-startup-window /prefetch:5"

try {
    New-ItemProperty -Path $runKeyPath -Name $autoLaunchName -Value "$edgePath $edgeArgs" -PropertyType String -Force | Out-Null
    Write-Output "Restored AutoLaunch registry key."
} catch {
    Write-Warning "Failed to restore AutoLaunch key: $_"
}

# Re-enable Edge Scheduled Tasks
$tasks = @(
    "\Microsoft\EdgeUpdate\MicrosoftEdgeUpdateTaskMachineCore",
    "\Microsoft\EdgeUpdate\MicrosoftEdgeUpdateTaskMachineUA"
)

foreach ($task in $tasks) {
    try {
        Write-Output "Re-enabling task: $task"
        schtasks /Change /TN $task /Enable | Out-Null
    } catch {
        Write-Warning "Failed to enable task: $task"
    }
}

# Re-enable "Continue running background apps when Microsoft Edge is closed"
try {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Edge" -Name "BackgroundModeEnabled" -Value 1
    Write-Output "Set BackgroundModeEnabled back to 1"
} catch {
    New-Item -Path "HKCU:\Software\Microsoft\Edge" -Force | Out-Null
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Edge" -Name "BackgroundModeEnabled" -Value 1 -PropertyType DWord -Force | Out-Null
    Write-Output "Created BackgroundModeEnabled = 1"
}

Write-Output "`n✅ Microsoft Edge auto-launch behavior re-enabled successfully."
