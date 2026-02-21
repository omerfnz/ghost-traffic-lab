#!/usr/bin/env fish
# GhostTraffic Lab — Emulator Setup & Test Script
# Grants all required permissions and runs a basic smoke test

set ADB ~/Android/Sdk/platform-tools/adb
set PKG com.ghosttraffic.ghost_traffic_lab
set SVC com.ghosttraffic.ghost_traffic_lab/com.ghosttraffic.ghost_traffic_lab.services.ClickerService

echo "🔍 Checking emulator..."
set devices ($ADB devices | grep -c "device\$")
if test $devices -eq 0
    echo "❌ No emulator found. Start one first."
    exit 1
end
echo "✅ Emulator connected"

echo ""
echo "📦 Installing APK..."
$ADB -s emulator-5554 install -r build/app/outputs/flutter-apk/app-debug.apk

echo ""
echo "🔐 Granting permissions..."

# 1. Accessibility Service — must be set via settings put
echo "  → Enabling Accessibility Service..."
$ADB shell settings put secure enabled_accessibility_services $SVC
$ADB shell settings put secure accessibility_enabled 1
sleep 1

# Verify accessibility
set acc ($ADB shell settings get secure enabled_accessibility_services)
if string match -q "*ClickerService*" $acc
    echo "  ✅ Accessibility Service enabled"
else
    echo "  ⚠️  Accessibility may need manual enable"
end

# 2. Overlay Permission
echo "  → Granting Overlay permission..."
$ADB shell appops set $PKG SYSTEM_ALERT_WINDOW allow
echo "  ✅ Overlay granted"

# 3. Battery Optimization bypass
echo "  → Disabling battery optimization..."
$ADB shell dumpsys deviceidle whitelist +$PKG 2>/dev/null
echo "  ✅ Battery optimization bypassed"

# 4. Exact Alarm — auto-granted on API < 31, check API 31+
echo "  → Checking Exact Alarm..."
set api ($ADB shell getprop ro.build.version.sdk | tr -d '\r')
if test $api -ge 31
    $ADB shell appops set $PKG SCHEDULE_EXACT_ALARM allow 2>/dev/null
end
echo "  ✅ Exact Alarm configured"

echo ""
echo "🚀 Launching app..."
$ADB shell am start -n $PKG/.MainActivity
sleep 3

echo ""
echo "📊 Permission Check Results:"
echo "  Accessibility: "$($ADB shell settings get secure accessibility_enabled)
echo "  Overlay: "$($ADB shell appops get $PKG SYSTEM_ALERT_WINDOW | grep -o "allow\\|deny\\|default")
echo "  Battery WL: "$($ADB shell dumpsys deviceidle whitelist | grep -c $PKG)" entries"

echo ""
echo "✅ Setup complete! Open the app and check:"
echo "   1. Dashboard should show 4/4 permissions"
echo "   2. Go to Payload Builder → add actions"
echo "   3. Press ARM SYSTEM"
echo "   4. Check Logs tab for execution output"
