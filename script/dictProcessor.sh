#!/bin/bash

# 1. 定義包含多個字典目錄的數組
directories=(
  "/path/to/dict1"
  "/path/to/dict2"
  "/path/to/dict3"
  # 可以繼續添加更多的目錄
)

# 2. 檢查所有目錄是否存在
for dir in "${directories[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "錯誤：目錄 '$dir' 不存在！"
    exit 1  # 退出腳本，返回錯誤代碼 1
  fi
done

# 3. 創建一個臨時文件來存放所有 .txt 文件的路徑
txt_files="/tmp/all_txt_files.txt"
> "$txt_files"  # 清空文件以確保它是空的

# 4. 遍歷每個目錄，查找 .txt 文件並將其絕對路徑寫入臨時文件
for dir in "${directories[@]}"; do
  find "$dir" -type f -name "*.txt" | xargs realpath >> "$txt_files"
done

# 5. 將文件分配給 10 個工作者，並行處理
split -n l/10 "$txt_files" /tmp/worker_  # 將所有 txt 文件按行分為 10 份


for i in {a..j}; do
  {
    # 將 worker_a, worker_b, ... worker_j 中的文件合併成 dict1.txt ~ dict10.txt
    while read -r file; do

awk -v min_length="$DICT_MIN_LENGTH" 'length($0) >= min_length' "$tempDictFile" | sort -u > "${tempDictFile}.tmp"
cat "$file" >> "dict$((10#${i}))".txt
    done < "/tmp/worker_$i"

    echo "Worker $i 完成了 dict$((10#${i})).txt"
  } &
done

# 6. 等待所有工作者完成
wait

# 7. 清理臨時的 worker 和 txt 文件
rm /tmp/worker_* "$txt_files"

echo "所有工作者已完成，文件合併完畢。"


