# Flutter Wireless Debugging Setup

## Quick Start - Pair Your Device

### Step 1: Enable Wireless Debugging on Your Phone
1. Go to **Settings** → **Developer Options**
2. Enable **Wireless Debugging**
3. Tap **Pair device with pairing code**
4. Note the **pairing code** and **IP address:port**

### Step 2: Pair Your Device (One-Time Setup)

Run this command in PowerShell (replace with your pairing code and port):

```powershell
adb pair 192.168.137.134:44655
```

When prompted, enter your pairing code: **891052**

### Step 3: Connect to Your Device

After pairing, connect using:

```powershell
adb connect 192.168.137.134:36149
```

> **Note**: The connection port (36149) is different from the pairing port (44655)

### Step 4: Verify Connection

Check if your device is connected:

```powershell
flutter devices
```

You should see your device listed (e.g., "RMX3853")

### Step 5: Run Your App

```powershell
flutter run
```

Flutter will automatically detect and use your connected device.

---

## Troubleshooting

### Device Not Found
- Make sure your phone and PC are on the **same Wi-Fi network** (192.168.137.x)
- Check if wireless debugging is still enabled on your phone
- Try disconnecting and reconnecting:
  ```powershell
  adb disconnect
  adb connect 192.168.137.134:36149
  ```

### Connection Lost
If connection drops, simply reconnect:
```powershell
adb connect 192.168.137.134:36149
```

### Need to Re-pair
If pairing expires, repeat Step 2 with a new pairing code from your phone.

---

## Quick Reference

| Command | Purpose |
|---------|---------|
| `adb pair <IP>:<PAIRING_PORT>` | Pair device (one-time) |
| `adb connect <IP>:<CONNECTION_PORT>` | Connect to device |
| `adb disconnect` | Disconnect device |
| `flutter devices` | List connected devices |
| `flutter run` | Run app on connected device |

---

## Your Current Setup

- **Device IP**: 192.168.137.134
- **Pairing Port**: 44655
- **Connection Port**: 36149 (check your phone for the actual port)
- **Pairing Code**: 891052

**First time setup:**
```powershell
# Pair (enter code 891052 when prompted)
adb pair 192.168.137.134:44655

# Connect
adb connect 192.168.137.134:36149

# Run app
flutter run
```
