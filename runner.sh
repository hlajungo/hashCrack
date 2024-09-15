#!/bin/bash

source "config"

if [ ! -f "$IhashesFile" ]; then
    echo "[Error]: $IhashesFile not found."
    exit 1
fi

if [ ! -d "$IdictDir" ]; then
    echo "[Error]: $IdictDir not found."
    exit 1
fi

mkdir -p "split_hash"
> "$md5_file"
> "$md5crypt_file"
> "$bcrypt_file"

current_time=$(date +"%Y%m%d%H%M")
