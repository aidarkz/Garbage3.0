#!/bin/bash

while true; do
    curl -s http://127.0.0.1:8282/status > /dev/null
    curl -s http://www.google.com > /dev/null
    sleep 60
done
