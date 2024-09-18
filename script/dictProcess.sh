#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/../config"

function ctrl_c() {
    echo "Ctrl+C detected."
    rm "${dictFile}.tmp"

    for file in "${dictWorkerFileArray[@]}"; do
        tmpFile="${file}.tmp"
        rm $tmpFile $file
    done

    rm "${preProcessedDict}Split_"*

    exit 1
}

trap ctrl_c SIGINT

#check user input dictDir is correct
for dir in "${IdictDir[@]}"; do
  if [[ ! -d "$dir" && ! -f "$dir" ]]; then
    echo "[Error]: $0 $dir doesn't exist."
    exit 1
  fi
done

echo "$(basename "$0") working start."

> "$dictNameFile"
for dir in "${IdictDir[@]}"; do
    echo "Using $dir"
    find "$dir" -type f -name "*.txt" >> "$dictNameFile"
    find "$dir" -type f -name "*.word" >> "$dictNameFile"
done

#all txt file in $dictNameFile
echo "exec $(wc -l < "$dictNameFile") word files."

#get length file by file
>"${dictNameFile}Length"
while IFS= read -r file; do
    wc -l "$file" >> "${dictNameFile}Length"
done < "$dictNameFile"



echo "distributing task to worker thread."
#create worker thread
dictWorkerFileArray=()
for i in $(seq -w 1 "$PARALLEL_JOBS"); do
    >"${dictWorkerName}${i}"
    dictWorkerFileArray+=("${dictWorkerName}${i}")
done

tempArray=(0 0 0 0 0 0 0 0 0 0
           0 0 0 0 0 0 0 0 0 0
           0 0 0 0 0 0 0 0 0 0
           0 0 0 0 0 0 0 0 0 0
           0 0 0 0 0 0 0 0 0 0
           0 0 0 0 0 0 0 0 0 0
           0 0 0 0 0 0 0 0 0 0
           0 0 0 0 0 0 0 0 0 0
           0 0 0 0 0 0 0 0 0 0
           0 0 0 0 0 0 0 0 0 0)

while IFS= read -r file; do
    value=$(echo "$file" | cut -d ' ' -f 1)
    realFile=$(echo "$file" | cut -d ' ' -f 2)
    minValue=${tempArray[0]}   # 設置最小值
    minIndex=0                 # 設置最小值的索引
    for ((i=0; i<${#dictWorkerFileArray[@]}; i++)); do
        if (( tempArray[$i] <= minValue )); then
            minValue=${tempArray[$i]}
            minIndex=$i
        fi
    done

    echo "$realFile" >> "${dictWorkerFileArray[$minIndex]}"
    tempArray[$minIndex]=$((tempArray[minIndex] + value))
done < "${dictNameFile}Length"
rm "${dictNameFile}Length"

#tell user each thread txt file
echo -n "split files into"
for i in "${dictWorkerFileArray[@]}"
do
   echo -n " $(wc -l < "$i")"
done
    echo -ne ".\n"


echo "merging file parallelly."

process_file() {
    file="$1"
    tmpFile="${file}.tmp"
    tmpFile2="${file}.tmp2"

    >"$tmpFile"
    >"$tmpFile2"
    while IFS= read -r dictFileName; do
        cat $dictFileName >> "$tmpFile2"
        grep -E '^[0-9a-zA-Z]{5,}$' "$tmpFile2" >> "$tmpFile"
    done < "$file"

    echo "file merge thread $(basename $file) finished."
}

export -f process_file


parallel process_file ::: "${dictWorkerFileArray[@]}"

echo "merging all word file to $dictFile"


# merge file
> "$dictFile"
for file in "${dictWorkerFileArray[@]}"; do
    tmpFile="${file}.tmp"
    cat "$tmpFile" >> "$dictFile"
    rm $tmpFile $file
done

echo "sorting $(basename $dictFile)"
sort --parallel="$PARALLEL_JOBS" -S 50% -u "$dictFile" > "${dictFile}.tmp"
mv "${dictFile}.tmp" "$dictFile"


${scriptDir}/ruleMerger.sh
echo "preproceeding rule x dict"

hashcat --stdout -r "$ruleFile" "$dictFile" > "$preProcessedDict"

echo "$(basename "$0") working done."
exit 0

echo "exclude the word < $DICT_MIN_LENGTH"

tmp2="$preProcessedDict.tmp"
tmp3="$preProcessedDict.tmp2"

split -l 200000000 -d "$preProcessedDict" "${preProcessedDict}Part"

preProcessedDictArray=("${preProcessedDict}Part"*)

for file in "${preProcessedDictArray[@]}"; do
  > "$tmp2"
  "$binDir/dictFliter.bin" "$file" "$tmp2" "$DICT_MIN_LENGTH"
  cat "$tmp2" >> "$tmp3"
done

mv "$tmp3" "$preProcessedDict"
rm "$tmp2"




echo "there are $(wc -l < "$preProcessedDict") words in ${preProcessedDict}"




