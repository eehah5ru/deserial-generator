#!/bin/sh

cat headers | while read line; do
  args="$args -H '$line'";
done
curl $args -X POST --data "@body" http://localhost:9292/screenplay
