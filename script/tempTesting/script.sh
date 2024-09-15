#!/bin/bash

# 定義變數
INPUT_DIR="/home/hlajungo/hipac3DataAll/hipac3data/hash/myTestSpace/new/hashCracker/script/tempTesting/SecLists-master"      # 要處理的目錄
OUTPUT_FILE="sorted_dict.txt"  # 最終輸出的文件
NUM_CORES=$(nproc)             # 自動獲取系統 CPU 核心數量
MIN_LENGTH=10                   # 篩選單詞的最小長度



# 檢查輸入目錄是否存在
if [ ! -d "$INPUT_DIR" ]; then
  echo "錯誤: 目錄 $INPUT_DIR 不存在。"
  exit 1
fi

# 創建/清空輸出文件
> "$OUTPUT_FILE"

# 收集所有 .txt 文件的內容並合併到臨時文件中
find "$INPUT_DIR" -type f -name "*.txt" | parallel cat {} > "${OUTPUT_FILE}.tmp"

# 使用 awk 過濾單詞，移除短於 $MIN_LENGTH 的單詞，並用 sort 去重
awk -v min_length="$MIN_LENGTH" 'length($0) >= min_length' "${OUTPUT_FILE}.tmp" | sort -u > "${OUTPUT_FILE}.sorted"

# 替換原文件
mv "${OUTPUT_FILE}.sorted" "$OUTPUT_FILE"

# 刪除臨時文件
rm "${OUTPUT_FILE}.tmp"

echo "處理完成，結果保存在 $OUTPUT_FILE"
