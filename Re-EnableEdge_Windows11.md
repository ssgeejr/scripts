Excellent — here’s the **matching PowerShell re-enable script** that safely **restores Edge's autolaunch behavior** in case something breaks or a dependent app (like Outlook or Teams) complains.

---

### 🔄 PowerShell Script: `Enable-EdgeAutoLaunch.ps1`

```powershell
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
```

---

### 💡 Usage

Same as before:

1. Open PowerShell as Admin
2. Save as `Enable-EdgeAutoLaunch.ps1`
3. Run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\Enable-EdgeAutoLaunch.ps1
```

You’re now safe to test turning it off and turning it back on without system risk.

Let me know if you want to wrap both into a single toggle script with a command-line flag like `-Enable` or `-Disable`.
