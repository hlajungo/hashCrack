#!/bin/bash

if [ -z "$1" ]; then
    echo "[Error]: No file provided."
    exit 1
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/../config"

tmpFile="$(basename "$0").tmp"
tmpFile2="$(basename "$0").tmp2"
while IFS= read -r string; do
  echo "$(echo "$string" | cut -d':' -f3)" >> "$tmpFile"
done < "$1"

cat "$tmpFile"

python2 "$IpackDir/statsgen.py"  $tmpFile -o $tmpFile2
python2 "$IpackDir/maskgen.py" $tmpFile2

cat $tmpFile2

[ -f "$tmpFile" ] && rm "$tmpFile"
[ -f "$tmpFile2" ] && rm "$tmpFile2"
