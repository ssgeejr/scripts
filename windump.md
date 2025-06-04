To **exclude your own IP address and the gateway (.1)** from a `WinDump` capture, you’ll want to apply a **capture filter** to skip those addresses. Here’s how you modify your command:

```bash
windump -i 1 -s 0 -w sysscan.060425.pcap not host YOUR_IP and not host GATEWAY_IP
```

Replace `YOUR_IP` and `GATEWAY_IP` with the actual IP addresses. For example, if:

* Your IP is `192.168.1.100`
* Gateway IP is `192.168.1.1`

Then:

```bash
windump -i 1 -s 0 -w sysscan.060425.pcap not host 192.168.1.100 and not host 192.168.1.1
```

### Explanation:

* `-i 1`: Use interface #1.
* `-s 0`: Capture the full packet.
* `-w sysscan.060425.pcap`: Write to a pcap file.
* `not host ... and not host ...`: BPF (Berkeley Packet Filter) syntax to exclude specific IPs from the capture.

### Optional: Only capture ARP and IP

If you're scanning devices on a subnet and want to capture only essential discovery traffic:

```bash
windump -i 1 -s 0 -w sysscan.060425.pcap 'ip and not host 192.168.1.100 and not host 192.168.1.1'
```

Excellent — that’s the clean setup! ✅ You're now capturing:

* **All IP traffic**
* **Excluding your own device and the gateway**
* **Full packet payloads**
* **Perfectly formatted for GrassMarlin and Network Monitor**

If you're planning to let this run for a while and want to keep things organized, you can automate the filename with a timestamp like this in PowerShell:

```powershell
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$filename = "sysscan.$timestamp.pcap"
windump -i 1 -s 0 -w $filename 'ip and not host 192.168.1.100 and not host 192.168.1.1'
```

Let me know when you're ready to parse or visualize the `.pcap` — we can do “who-talked-to-who” maps, external destinations, MAC/IP mappings, etc.
