#!/bin/bash

# --- Configuration ---
API_URL="http://36.91.166.189/api/wrsng/status/update/"
WRS_CODE="stageof_JAY"
LAT="-2.514"
LONG="140.7042"
REMARK="Stageof Jayapura"
#-2.5143717398956187, 140.70417005179408
# --- 1. Get Dynamic Date ---
CURRENT_DATE=$(date +"%Y-%m-%d")

# --- 2. Check Browser Status (Chrome OR Chromium OR Firefox) ---
# We use pgrep without '-x' (exact match) so it catches variations like:
# 'google-chrome-stable', 'chromium-browser', or 'firefox-esr'.
if pgrep "chrome" > /dev/null || pgrep "chromium" > /dev/null || pgrep "firefox" > /dev/null; then
    CHROME_STATUS=1
else
    CHROME_STATUS=0
fi

# --- 3. Check Display/PC Status ---
# PC is running if script is running.
DISPLAY_STATUS=1

# --- 4. Construct JSON Payload ---
JSON_PAYLOAD=$(printf '{"date": "%s", "wrs_code": "%s", "latitude": %s, "longitude": %s, "display_status": %d, "chrome_status": %d, "remark": "%s"}' \
    "$CURRENT_DATE" \
    "$WRS_CODE" \
    "$LAT" \
    "$LONG" \
    "$DISPLAY_STATUS" \
    "$CHROME_STATUS" \
    "$REMARK")

# --- 5. Send Request ---
HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" -d "$JSON_PAYLOAD" "$API_URL")

# --- 6. Logging ---
echo "[$(date)] Code: $HTTP_RESPONSE | Chrome/Browser: $CHROME_STATUS" >> ~/cron_api.log