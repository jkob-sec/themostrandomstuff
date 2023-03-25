#!/bin/bash

# i love you chatgpt
# Check if a file has been provided as an argument
if [[ -z "$1" ]]; then
  echo "Usage: $0 <file>"
  exit 1
fi

# Check if the file exists
if [[ ! -f "$1" ]]; then
  echo "Error: $1 does not exist"
  exit 1
fi

# Remove lines that contain digits
sed '/[0-9]/d' "$1" > "$1.tmp"

# Remove lines where first letter is repeated exactly 3 times
sed '/^\(.\)\1\1\1/d' "$1.tmp" > "$1.tmp2"

# Remove lines longer than 25 characters
awk 'length <= 25' "$1.tmp2" > "$1.tmp3"

# Remove duplicates but keep case sensitive lines
awk '{a[$0]++}END{for(i in a)if(a[i]==1)print i}' "$1.tmp3" > "$1.filtered"

# Clean up temporary files
rm "$1.tmp" "$1.tmp2" "$1.tmp3"

echo "Filtered file saved to $1.filtered"
