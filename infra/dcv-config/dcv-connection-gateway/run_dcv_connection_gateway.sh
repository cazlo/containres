#!/bin/sh

# Start the dcv-connection-gateway process
/usr/libexec/dcv-connection-gateway/dcv-connection-gateway --config /etc/dcv-connection-gateway/dcv-connection-gateway.conf &

# Get the PID of the process
GATEWAY_PID=$!

# Function to handle the termination signal
cleanup() {
  echo "Stopping dcv-connection-gateway..."
  kill $GATEWAY_PID
  wait $GATEWAY_PID
  exit 0
}

# Trap termination signals to clean up the process
trap cleanup INT TERM

# Retry mechanism for tailing the log file
LOG_FILE="/var/log/dcv-connection-gateway/gateway.log"
RETRIES=30
DELAY=2

for i in $(seq 1 $RETRIES); do
  if [ -f "$LOG_FILE" ]; then
    tail -f $LOG_FILE &
    TAIL_PID=$!
    break
  else
    echo "Log file not found, retrying in $DELAY seconds... ($i/$RETRIES)"
    sleep $DELAY
  fi
done

# If tail command failed after retries, exit the script
if [ -z "$TAIL_PID" ]; then
  echo "Failed to start tailing the log file after $RETRIES attempts. Exiting."
  kill $GATEWAY_PID
  exit 1
fi

# Wait for the dcv-connection-gateway process to terminate
wait $GATEWAY_PID

# Kill the tail process if the dcv-connection-gateway process terminates
kill $TAIL_PID
wait $TAIL_PID
