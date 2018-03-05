#!/bin/bash
/start web &
sleep 5

output=$(curl --fail --retry 20 --retry-delay 5 --verbose --silent "localhost:${PORT}")
echo "${output}"
if [ "${output}" = "OK" ]; then
  exit 0
else
  exit 1
fi
