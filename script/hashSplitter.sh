#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/../config"

echo "$(basename "$0") working start"

>"$md5File"
>"$md5cryptFile"
>"$bcryptFile"

# 逐行讀取哈希文件並根據哈希類型進行分類
while IFS= read -r hash; do
    if [[ "$hash" =~ ^[0-9a-fA-F]{32}$ ]]; then
        # md5
        echo "$hash" >> "$md5File"
    elif [[ "$hash" == \$1\$* ]]; then
        # md5crypt
        echo "$hash" >> "$md5cryptFile"
    elif [[ "$hash" == \$2b\$* ]]; then
        # bcrypt
        echo "$hash" >> "$bcryptFile"
    else
        echo "[Error]: Unknown hash $hash"
    fi
done < "$IhashesFile"

echo "$(basename "$0") working done"
