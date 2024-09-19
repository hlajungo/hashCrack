#!/bin/bash

if [ ! -f "$1" ]; then
    echo "[Error]: doesn't input any file."
    exit 1
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/../config"

tempFile2=$(mktemp --suffix=.txt)

# 合併結果文件
cat "$@" > "$tempFile2"

awk -F':' '{print $2 ":" $3}' "$tempFile2" > "$tempFile2".tmp
mv "$tempFile2".tmp "$tempFile2"


>"$outputFile"
while IFS= read -r hash; do

if grep -q "^$hash" "$tempFile2"; then
    grep "^$hash" "$tempFile2" >> "$outputFile"
else
    echo "$hash" >> "$outputFile"
fi
done < "$IhashesFile"

rm  "$tempFile2"

# 997:498039e1c2bf8f3cbfcf75b60580bb85:october31
# 498039e1c2bf8f3cbfcf75b60580bb85:october31

