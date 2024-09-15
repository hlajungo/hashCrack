#!/bin/bash
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/../config"

    #python2 statsgen.py $file -o temp.masks
    #python2 maskgen.py temp.masks --targettime 1200

    #-a 6 == mask+dict
    #-a 3 == mask

    #hashcat -a 3 -m 0 -w 3 -O -o $resultFile  --increment --increment-min=1 --increment-max=15 $hashes_file ?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?l?d



controller="999"
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
    -r "/home/hlajungo/hipac3DataAll/hipac3data/hash/myTestSpace/new/hashCracker/rule/best64.rule" \
    $md5File \
    "$tempDictFile"

        ;;
    "6")#dict+mask

        ;;
    "7")#mask+dict

        ;;
    *)
        echo "Error: $(basename "$0") :Unknown controller type."
        ;;
esac

# add to data , rempve the same ,order by length of line
cat $md5ResultFile >> "${dataDir}/md5Result.txt"
sort -u "${dataDir}/md5Result.txt" > "${dataDir}/md5Result.tmp"
awk '{ print length, $0 }' "${dataDir}/md5Result.tmp" | sort -n | cut -d ' ' -f2- > "${dataDir}/md5Result.tmp2"
mv "${dataDir}/md5Result.tmp2" "${dataDir}/md5Result.txt"



    #--increment --increment-min=1 --increment-max=20 



# hashcat --restore --session=md5session1 --restore-file-path="temp/restore/md5session1"

