#!/bin/sh
HASS_WEBHOOK_ID=$(jq --raw-output '.hass_webhook_id' /data/options.json)
if [ -z "$HASS_WEBHOOK_ID" ]; then
    echo "Error: 'hass_webhook_id' is not defined in options.json. Please configure the add-on."
    exit 1
else
    curl -X POST "http://homeassistant:8123/api/webhook/$HASS_WEBHOOK_ID"
fi
