#!/bin/bash
/start web &

function do_curl {
  curl --ipv4 --fail --retry 60 --retry-delay 1 --verbose --silent "http://localhost:${PORT}"
}

function establish {
  local retries=5
  local count=0

  while [ ${count} -lt ${retries} ]
  do
    count=$((count + 1))
    if ! do_curl | grep -F "Connection refused";
    then
      break
    else
      sleep 1
    fi
  done
}
establish

function do_test {
  local retries=5
  local count=0

  while [ ${count} -lt ${retries} ]
  do
    count=$((count + 1))
    if do_curl | grep -F "OK";
    then
      exit 0
    else
      sleep 1
    fi
  done
  exit 1
}
do_test
