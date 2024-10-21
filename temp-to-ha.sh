#!/bin/bash

# Home Assistant Settings
url_base="http://192.168.1.174:8123/api/states"
token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI3ODE0MThhZWQ5ZDA0ZGQ4ODc4ZTcwNGY3MDRiMGQ2MyIsImlhdCI6MTcyOTQ5MTUxNywiZXhwIjoyMDQ0ODUxNTE3fQ.zOg6Gdzg2s6zhateCwFUiis8RI0Ri1jmAYxww1qi4og"

# Server name
srv_name="hiveos"

# Constants for device info
DEVICE_IDENTIFIERS='["n100_server"]'
DEVICE_NAME="Intel N100"
DEVICE_MANUFACTURER="AC8-N"
DEVICE_MODEL="N100 16 512"

# Function to send data to Home Assistant
send_to_ha() {
  local sensor_name=$1
  local temperature=$2
  local friendly_name=$3
  local icon=$4
  local unique_id=$5

  local url="${url_base}/${sensor_name}"
  local device_info="{\"identifiers\":${DEVICE_IDENTIFIERS},\"name\":\"${DEVICE_NAME}\",\"manufacturer\":\"${DEVICE_MANUFACTURER}\",\"model\":\"${DEVICE_MODEL}\"}"
  local payload="{\"state\":\"${temperature}\",\"attributes\": {\"friendly_name\":\"${friendly_name}\",\"icon\":\"${icon}\",\"state_class\":\"measurement\",\"unit_of_measurement\":\"°C\",\"device_class>

  curl -X POST -H "Authorization: Bearer ${token}" -H 'Content-type: application/json' --data "${payload}" "${url}"
}

# Send CPU package temperature
cpu_temp=$(sensors | grep 'Package id 0' | awk '{print $4}' | sed 's/+//;s/°C//')
send_to_ha "sensor.${srv_name}_cpu_temperature" "${cpu_temp}" "CPU Package Temperature" "mdi:cpu-64-bit" "${srv_name}_cpu_temp"
