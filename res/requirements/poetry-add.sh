#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Check if the script received the required argument
if [ $# -lt 1 ]; then
  echo "Usage: $0 path/to/requirements.txt [--dev]"
  exit 1
fi

# Check if the provided file exists
if [ ! -f "$1" ]; then
  echo "File not found: $1"
  exit 1
fi

# Check if the --dev flag is provided
DEV_FLAG=false
if [ "$2" == "--dev" ]; then
  DEV_FLAG=true
fi

# Read each line in the provided requirements.txt file
while IFS= read -r line || [ -n "$line" ]; do
  # Skip empty lines and comments
  if [[ -n "$line" && ! "$line" =~ ^# ]]; then
    if [ "$DEV_FLAG" == true ]; then
      echo "Adding dev-dependency: $line"
      poetry add --group dev "$line"
    else
      echo "Adding dependency: $line"
      poetry add "$line"
    fi
  fi
done < "$1"
