#!/bin/bash

if [ ! -f "$1" ]; then
    echo "[Error]: doesn't input any file."
    exit 1
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/../config"

tmpFile="$(basename "$0").tmp"

# 合併結果文件
cat "$@" > "$tmpFile"

awk -F':' '{print $2 ":" $3}' "$tmpFile" > "$tmpFile.tmp" && mv "$tmpFile.tmp" "$tmpFile"


>"$outputFile"
while IFS= read -r hash; do

if grep -q "^$hash" "$tmpFile"; then
    grep "^$hash" "$tmpFile" >> "$outputFile"
else
    echo "$hash" >> "$outputFile"
fi
done < "$IhashFile"

rm  "$tmpFile"

# 997:498039e1c2bf8f3cbfcf75b60580bb85:october31
# 498039e1c2bf8f3cbfcf75b60580bb85:october31

