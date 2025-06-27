
### Step 1: Get a list of saved Wi-Fi profiles:

```powershell
netsh wlan show profiles
```

### Step 2: Display the password for a specific network:

Replace `NETWORK_NAME` with the actual profile name from the previous list.

```powershell
netsh wlan show profile name="NETWORK_NAME" key=clear
```

Look under:

```
Security settings
    Key Content            : your_wifi_password
```

---

### Example:

```powershell
netsh wlan show profile name="HomeWiFi" key=clear
```

If you're using this in a script and want to extract just the password:

```powershell
(netsh wlan show profile name="HomeWiFi" key=clear) |
Select-String "Key Content" |
ForEach-Object { ($_ -split ":")[1].Trim() }
```

# Get all Wi-Fi profile names
$profiles = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object {
    ($_ -split ":")[1].Trim()
}

# Loop through each profile and get the password
foreach ($profile in $profiles) {
    $details = netsh wlan show profile name="$profile" key=clear
    $passwordLine = $details | Select-String "Key Content"
    
    if ($passwordLine) {
        $password = ($passwordLine -split ":")[1].Trim()
    } else {
        $password = "[No Password Found or Not Stored]"
    }

    Write-Output "SSID: $profile | Password: $password"
}
