#!/bin/bash
# Script 4: Log File Analyzer

# Author: Tanishq Shrivastava | Reg No: 24BCY10162
# Usage: ./script4_log_analyzer.sh <logfile> [keyword]
# Example: ./script4_log_analyzer.sh /var/log/syslog error

LOGFILE=$1
KEYWORD=${2:-"error"}
COUNT=0
ATTEMPTS=0
MAX_RETRIES=3

if [ -z "$LOGFILE" ]; then
    echo "Usage: $0 <logfile> [keyword]"
    echo "Example: $0 /var/log/syslog error"
    exit 1
fi

# retry loop if file not found or empty, up to MAX_RETRIES times
while [ ! -f "$LOGFILE" ] && [ $ATTEMPTS -lt $MAX_RETRIES ]; do
    ATTEMPTS=$((ATTEMPTS + 1))
    echo "Attempt $ATTEMPTS: File '$LOGFILE' not found. Retrying in 2 seconds..."
    sleep 2
done

if [ ! -f "$LOGFILE" ]; then
    echo "Error: '$LOGFILE' could not be found after $MAX_RETRIES attempts."
    exit 1
fi

if [ ! -s "$LOGFILE" ]; then
    echo "Warning: '$LOGFILE' exists but is empty. Nothing to analyze."
    exit 0
fi

echo "Log Analyzer"
echo "=================================="
echo "File    : $LOGFILE"
echo "Keyword : $KEYWORD"
echo "----------------------------------"

while IFS= read -r LINE; do
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        COUNT=$((COUNT + 1))
    fi
done < "$LOGFILE"

echo "Matches : $COUNT lines contain '$KEYWORD'"
echo ""

if [ $COUNT -gt 0 ]; then
    echo "Last 5 matching lines:"
    echo "----------------------------------"
    grep -i "$KEYWORD" "$LOGFILE" | tail -5
else
    echo "No matches found for '$KEYWORD' in this log file."
fi

echo ""
echo "Done."
