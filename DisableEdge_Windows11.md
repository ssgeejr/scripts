Here's a **safe PowerShell script** that:

1. **Disables Edge AutoLaunch registry keys**.
2. **Disables Edge scheduled tasks**.
3. **Turns off background apps setting via registry**.

This **does not uninstall Edge**, nor break Windows components like WebView2.

---

### ⚙️ PowerShell Script: `Disable-EdgeAutoLaunch.ps1`

```powershell
# Disable Microsoft Edge AutoLaunch Registry Entry
$runKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
Get-ItemProperty -Path $runKeyPath | ForEach-Object {
    $_.PSObject.Properties.Name | Where-Object { $_ -like "MicrosoftEdgeAutoLaunch_*" } | ForEach-Object {
        Write-Output "Removing registry key: $_"
        Remove-ItemProperty -Path $runKeyPath -Name $_ -Force
    }
}

# Disable Edge Scheduled Tasks (Run as Administrator)
$tasks = @(
    "\Microsoft\EdgeUpdate\MicrosoftEdgeUpdateTaskMachineCore",
    "\Microsoft\EdgeUpdate\MicrosoftEdgeUpdateTaskMachineUA"
)

foreach ($task in $tasks) {
    try {
        Write-Output "Disabling task: $task"
        schtasks /Change /TN $task /Disable | Out-Null
    } catch {
        Write-Warning "Failed to disable task: $task"
    }
}

# Turn off "Continue running background apps when Microsoft Edge is closed"
$edgeBgAppsReg = "HKCU:\Software\Microsoft\Edge\BackgroundModeEnabled"
if (Test-Path $edgeBgAppsReg) {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Edge" -Name "BackgroundModeEnabled" -Value 0
    Write-Output "Set BackgroundModeEnabled to 0"
} else {
    New-Item -Path "HKCU:\Software\Microsoft\Edge" -Force | Out-Null
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Edge" -Name "BackgroundModeEnabled" -Value 0 -PropertyType DWord -Force | Out-Null
    Write-Output "Created BackgroundModeEnabled = 0"
}

Write-Output "`n✅ Microsoft Edge auto-launch behavior reduced successfully."
```

---

### ✅ How to Use:

1. **Open PowerShell as Administrator**
2. Save the script as `Disable-EdgeAutoLaunch.ps1`
3. Run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\Disable-EdgeAutoLaunch.ps1
```

Let me know if you'd like to add:

* Telemetry block
* Network access block (via firewall)
* Re-enable script (to undo these changes)

I can package it cleanly for you.
