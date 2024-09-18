#!/bin/bash
SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/../config"

    #python2 statsgen.py $file -o temp.masks
    #python2 maskgen.py temp.masks --targettime 1200

    #-a 6 == mask+dict
    #-a 3 == mask

    #hashcat -a 3 -m 0 -w 3 -O -o $resultFile  --increment --increment-min=1 --increment-max=15 $hashes_file ?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?l?d



controller="0"
case $controller in
    "3")#brute force and mask
    hashcat -a 3 -m 0 \
    -w 3 -O \
    --session=md5session1 --restore-file-path="$restoreDir/md5session1" \
    -o $md5ResultFile --outfile-format=1,2,6 --outfile-check-timer=30 --potfile-path="$potFile" \
    --increment --increment-min=1 --increment-max=20 \
    $md5File

        ;;
    "0")#dict
    hashcat -a 0 -m 0 \
    -w 3 -O \
    --session=md5session1 --restore-file-path="$restoreDir/md5session1" \
    -o $md5ResultFile --outfile-format=1,2,6 --outfile-check-timer=30 --potfile-path="$potFile" \
    $md5File \
    "$preProcessedDict"

        ;;
    "6")#dict+mask
    hashcat --stdout -r "/media/hlajungo/D/linux/rule/best64.rule" "$dictFile" > processed_dictionary.txt
        ;;
    "7")#mask+dict
        ;;
    *)
        echo "Error: $(basename "$0") :Unknown controller type."
        ;;
esac

# rempve the same
cat $md5ResultFile >> "$md5DataFile"
cut -f2,3 -d ":" "$md5DataFile" > "${md5DataFile}.tmp2" #tmp2 1:2:3 -> 2:3
cut -f1 -d ":" "$md5DataFile" > "${md5DataFile}.tmp3" #tmp3 1:2:3 -> 1
awk '!seen[$0]++ { print } seen[$0] == 2 { print "PLACEHOLDER_ROW" }' "$md5DataFile.tmp2" > "${md5DataFile}.tmp" #tmp 2:3 with place holder
paste -d ":" "$md5DataFile.tmp3" "$md5DataFile.tmp" > "$md5DataFile.tmp4"
grep -v "PLACEHOLDER_ROW" "$md5DataFile.tmp4" > "$md5DataFile"

rm "$md5DataFile.tmp"*

    #--increment --increment-min=1 --increment-max=20 

#--runtime

# hashcat --restore --session=md5session1 --restore-file-path="temp/restore/md5session1"

