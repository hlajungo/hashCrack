#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/../config"


# 檢查輸入參數是否是有效的實際路徑
for file in "$@"; do
    if [ ! -f "$file" ]; then
        echo "[Error]: File does not exist or is not a regular file: $file"
        exit 1
    fi
    # 獲取文件的實際路徑並確認是否存在
    realpath "$file" > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "[Error]: Cannot resolve the real path for file: $file"
        exit 1
    fi
done

tempFile=$(mktemp --suffix=.txt)
"$IhashesFile" > "$tempFile"

tempFile2=$(mktemp --suffix=.txt)
tempFile3=$(mktemp --suffix=.txt)

# 合併結果文件
cat "$@" > "$tempFile2"

awk -F':' '{print $2 ":" $3}' "$tempFile2" > "$tempFile3"

# 按原始文件的順序排列結果
while IFS= read -r hash; do

if grep -q "^$hash" "$tempFile3"; then
    grep "^$hash" "$tempFile3" >> "$outputFile"
else
    echo "$hash" >> "$outputFile"
fi
done < "$tempFile"

rm "$tempFile" "$tempFile2" "$tempFile3"

# 997:498039e1c2bf8f3cbfcf75b60580bb85:october31
# 498039e1c2bf8f3cbfcf75b60580bb85:october31


