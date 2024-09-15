#!/bin/bash

# 定義變數
INPUT_DIR="/home/hlajungo/hipac3DataAll/hipac3data/hash/myTestSpace/new/hashCracker/script/tempTesting/SecLists-master"      # 要處理的目錄
OUTPUT_FILE="sorted_dict.txt"  # 最終輸出的文件
MIN_LENGTH=10                   # 篩選單詞的最小長度

# 檢查輸入目錄是否存在
if [ ! -d "$INPUT_DIR" ]; then
  echo "錯誤: 目錄 $INPUT_DIR 不存在。"
  exit 1
fi

# 創建/清空輸出文件
> "$OUTPUT_FILE"

# 遞迴地收集所有 .txt 文件的內容並合併
find "$INPUT_DIR" -type f -name "*.txt" -exec cat {} + >> "$OUTPUT_FILE"

# 根據長度過濾單詞，移除短於 $MIN_LENGTH 的單詞，並去重
awk -v min_length="$MIN_LENGTH" 'length($0) >= min_length' "$OUTPUT_FILE" | sort -u > "${OUTPUT_FILE}.tmp"

# 替換原文件
mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"

echo "處理完成，結果保存在 $OUTPUT_FILE"
