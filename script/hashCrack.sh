#!/bin/bash

rootDir="/media/hlajungo/D/linux/repo/princeprocessor"

IdictFile="$rootDir/output"
IruleFile="$rootDir/rules/prince_generated.rule"

hashFile="$rootDir/hashmd5"
passwordFile="$rootDir/password" && touch $passwordFile
potFile="$rootDir/pot"
sessionName="1"
restoreFilePath="$rootDir/$sessionName.restore"


hashType="0"
# 0 md5

attackMode="3"
# 3 brute-force rule mask
# 0 dict rule

finalCommand=""
finalCommand+="hashcat -a $attackMode -m $hashType "
finalCommand+="-o $passwordFile --outfile-format=1,2,6 --outfile-check-timer=30 --potfile-path="$potFile" "
finalCommand+="--session="$sessionName" --restore-file-path="$restoreFilePath" "

finalCommand+="-w 3 -O --increment --increment-min=1 --increment-max=100  --runtime=300 \
    $hashFile \
    ?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?l?d"


controlMode="1"
# 0 brute-force+mask runtime=5min
case $controlMode in
    "0")
    finalCommand+="-w 3 -O --increment --increment-min=1 --increment-max=100  --runtime=300 \
    $hashFile \
    ?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?l?d"

        ;;
    "3")
    hashcat -a $attackMode -m $hashType \
    -w 3 -O --runtime=31556926 \
    --session="$sessionName" --restore-file-path="$restoreFilePath" \
    -o $passwordFile --outfile-format=1,2,6 --outfile-check-timer=30 --potfile-path="$potFile" \
    -r $IruleFile \
    $hashFile \
    $IdictFile

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

eval $finalCommand

exit 0

# rempve the same
cat $md5ResultFile >> "$md5DataFile"
cut -f2,3 -d ":" "$md5DataFile" > "${md5DataFile}.tmp2" #tmp2 1:2:3 -> 2:3
cut -f1 -d ":" "$md5DataFile" > "${md5DataFile}.tmp3" #tmp3 1:2:3 -> 1
awk '!seen[$0]++ { print } seen[$0] == 2 { print "PLACEHOLDER_ROW" }' "$md5DataFile.tmp2" > "${md5DataFile}.tmp" #tmp 2:3 with place holder
paste -d ":" "$md5DataFile.tmp3" "$md5DataFile.tmp" > "$md5DataFile.tmp4"
grep -v "PLACEHOLDER_ROW" "$md5DataFile.tmp4" > "$md5DataFile"

rm "$md5DataFile.tmp"*

#--runtime
