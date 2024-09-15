#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/../config"

>"$tempDictFile"

# 遞迴地收集所有 .txt 文件的內容並合併
find "$dictDir" -type f -name "*.txt" -exec cat {} + >> "$tempDictFile"

# 根據長度過濾單詞，移除短於 $MIN_LENGTH 的單詞，並去重
awk -v min_length="$DICT_MIN_LENGTH" 'length($0) >= min_length' "$tempDictFile" | sort -u > "${tempDictFile}.tmp"

# 替換原文件
mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"


