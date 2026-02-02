# Quick Wireless Pairing Script

## ✅ Pairing Complete!

Your device has been successfully paired with code **891052**.

## 🔌 Next Step: Connect Your Device

**On your phone:**
1. Go to **Settings** → **Developer Options** → **Wireless Debugging**
2. Look for the **IP address & Port** (NOT the pairing port)
3. It should look like: `192.168.137.134:XXXXX` (where XXXXX is a 5-digit port number)

**Then run this command** (replace XXXXX with the actual port from your phone):

```powershell
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" connect 192.168.137.134:XXXXX
```

## 🚀 Run Your App

Once connected, simply run:

```powershell
flutter run
```

Flutter will automatically detect your device!

---

## 📝 Common Ports

The connection port is usually different from the pairing port (44655). Common ports include:
- 36149
- 37847  
- 41893
- 43215

Check your phone's Wireless Debugging screen for the exact port.

---

## 🔄 Quick Reference Commands

```powershell
# Connect (replace XXXXX with your port)
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" connect 192.168.137.134:XXXXX

# Check connected devices
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" devices

# Run Flutter app
flutter run

# Disconnect
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" disconnect
```
