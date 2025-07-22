#!/bin/bash

while true; do
  curl -s http://127.0.0.1:8080/status > /dev/null
  sleep 30
done
