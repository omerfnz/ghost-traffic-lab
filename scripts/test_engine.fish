#!/usr/bin/env fish
# GhostTraffic Lab - Direct Engine Integration Test

set ADB ~/Android/Sdk/platform-tools/adb
set PKG com.ghosttraffic.ghost_traffic_lab
set SVC com.ghosttraffic.ghost_traffic_lab/.services.BotService

echo "🚀 Bypassing UI and jumping straight to PayloadEngine..."

# JSON payload: Launch Chrome -> Wait 3s -> Open URL (Wikipedia)
set PAYLOAD '[
  {"action":"launch", "package_name":"com.android.chrome"},
  {"action":"wait", "duration":3000},
  {"action":"open_url", "url":"https://en.wikipedia.org/wiki/Special:Random"},
  {"action":"wait", "duration":4000},
  {"action":"home"}
]'

echo "📜 Injecting Payload:"
echo $PAYLOAD

# Trigger the BotService natively
$ADB -s emulator-5554 shell am start-foreground-service -n $SVC \
  --es extra_target_pkg "com.android.chrome" \
  --es extra_payload "'$PAYLOAD'"

echo ""
echo "🔥 Payloads dispatched! Watching GhostTraffic logs (Press Ctrl+C to stop)..."
$ADB -s emulator-5554 logcat -s "GhostTraffic"
