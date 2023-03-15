#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Error - missing URL"
  exit 1
fi

while true; do
  # Sleep for up to 15 seconds
  sl=$(( $RANDOM % 15 ))
  echo "Sleep for $sl"
  sleep $sl
  # Get a random value up to 100
  tt=$(( $RANDOM % 100 + 1 ))
  echo "Got $tt"
  t2=$(( tt % 2 ))
  echo "$tt % 2 = $t2"
  if [ $t2 -eq 0 ]; then echo "curl $1/"; curl "$1" &> /dev/null; fi
  t3=$(( tt % 3 ))
  echo "$tt % 3 = $t3"
  if [ $t3 -eq 0 ]; then echo "curl $1/?slow"; curl "$1"/?slow &> /dev/null; fi
  t5=$(( tt % 5 ))
  echo "$tt % 5 = $t5"
  if [ $t5 -eq 0 ]; then echo "curl $1/err"; curl "$1"/err &> /dev/null; fi
done
