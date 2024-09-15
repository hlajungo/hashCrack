#!/bin/bash

if [ -z "$1" ]; then
    echo "[Error]: No file provided."
    exit 1
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/../config"

tempFile=$(mktemp --suffix=.txt)

while IFS= read -r string; do

    password=$(echo "$string" | cut -d':' -f3)

    echo "$password" >> "$tempFile"
done < "$1"


python2 "$IpackDir/statsgen.py"  $tempFile -o $maskFile
python2 "$IpackDir/maskgen.py" $maskFile

cat $maskFile
