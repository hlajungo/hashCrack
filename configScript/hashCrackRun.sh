#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/../config"

sessionName="1"
restoreFilePath="$restoreDir/$sessionName.restore"


#
# hash
#

# 0 md5
#hashFile="$splitHashDir/0.hash"
#hashType="0"
#data0File="${dataDir}/cracked0"

#hashFile="$splitHashDir/500.hash"
#hashType="500"
#data0File="${dataDir}/cracked500"

hashFile="$splitHashDir/3200.hash"
hashType="3200"
data0File="${dataDir}/cracked3200"

# 3 brute-force mask
# 0 dict rule
# 1 combine dict
# 6 dict+masks
# 7 masks+dict
attackMode=""


#
# dict
#
IdictFile=()
#IdictFile+=("/media/hlajungo/D/linux/hashCrack/thirdParty/dict/top_english_words_lower_1000000.txt")
#IdictFile+=("/media/hlajungo/D/linux/hashCrack/thirdParty/dict/rockyou.txt")
IdictFile+=("/media/hlajungo/D/linux/dict/dictQuestion")

#
# rule
#

IruleDir=()
IruleDir+=("/media/hlajungo/D/linux/repo/hashcat-6.2.6/rules/rockyou-30000.rule")
#IruleDir+=("/media/hlajungo/D/linux/repo/hashcat-6.2.6/rules")
tmpRuleFile="$(basename "$0").rule.tmp"
$coreScriptDir/ruleMerge.sh  "${IruleDir[@]}" > $tmpRuleFile

#
#mask
#


finalCommand=""
finalCommand+="hashcat -m $hashType "
finalCommand+="-o $data0File --outfile-format=1,2,6 --outfile-check-timer=30 --potfile-path="$potFile" "
finalCommand+="--session="$sessionName" --restore-file-path="$restoreFilePath" "
finalCommand+="-w 3 -O  --segment-size 2048 --runtime=31556926 "
#finalCommand+="-w 3 -O --runtime=31556926 "

#  l | [a-z] | u | [A-Z] | d | [0-9]
#  s |  !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
#  a | ?l?u?d?s
#  h | [0-9a-f] | H | [0-9A-F]
#  b | 0x00 - 0xff

# [a-z] + [0-9]
maskAll="?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a?a"
mask0A_="?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?s?d?u"
maskAa_="?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?l?s?u"
mask0a_="?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?l?d?s"
mask0A="?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?d?u"
maskAa="?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?l?u"
mask0a="?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?l?d"
maskA_="?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?s?u"
mask0_="?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?d?s"
maska_="?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?l?s"
maskA="?u?u?u?u?u?u?u?u?u?u?u?u?u?u?u?u?u?u?u?u?u?u?u?u?u"
mask0="?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d"
maska="?l?l?l?l?l?l?l?l?l?l?l?l?l?l?l?l?l?l?l?l?l?l?l?l?l?l"
mask_="?s?s?s?s?s?s?s?s?s?s?s?s?s?s?s?s?s?s?s?s?s?s?s?s?s?s"
tmpMask="$mask0A_"

# 000 brute-force runtime=5min
# 001 brute-force + mask
# 002 combine two dict
# 100 generate mask dict
controlMode="000"
case $controlMode in
    "000")# 000 brute-force runtime=30min
    attackMode="3"
    finalCommand+="-a $attackMode "
    finalCommand+="--increment --increment-min=1 --increment-max=100  --runtime=1800 "
    finalCommand+="$hashFile "
    finalCommand+="$maskAll "

        ;;
    "001")# 000 brute-force runtime=30min
    attackMode="3"
    finalCommand+="-a $attackMode "
    finalCommand+="--increment --increment-min=7 --increment-max=100  --runtime=1800 "
    finalCommand+="$hashFile "
    finalCommand+="$tmpMask "

        ;;
    "010")# dict
    attackMode="0"
    finalCommand+="-a $attackMode "
    finalCommand+="$hashFile "
    finalCommand+="${IdictFile[@]} "

        ;;
    "011")# dict + rule
    attackMode="0"
    finalCommand+="-a $attackMode "
    finalCommand+="-r $tmpRuleFile "
    finalCommand+="$hashFile "
    finalCommand+="${IdictFile[@]} "

        ;;
    "004")# 004 dict + mask
    # 6 dict+masks
    attackMode="6"
    finalCommand+="-a $attackMode "
    finalCommand+="$hashFile "
    finalCommand+=" ${IdictFile[@]} "
    finalCommand+="$tmpMask "

        ;;
    "005")# 004 mask + dict
    attackMode="7"
    finalCommand+="-a $attackMode "
    finalCommand+="$hashFile "
    finalCommand+=" ${IdictFile[@]} "
    finalCommand+="$tmpMask "


        ;;
    "100")# 100 generate mask dict
    finalCommand=""
    attackMode="3"
    createLength="6"
    createMask="?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d?d"
    outputDictName="pure_d_$createLength"
    finalCommand+="hashcat --stdout -a $attackMode --markov-disable --increment --increment-min=$createLength --increment-max=$createLength $createMask > "$outputDictName" "

        ;;
    "101")
# THIS PART IS NOT DONE YET
    finalCommand=""
    attackMode="1"
    outputDictName="dictCombine_"
    finalCommand+="hashcat --stdout -a $attackMode  $createMask > "$outputDictName" "
        ;;
    *)
        echo "Error: $(basename "$0") :Unknown controller type."
        ;;
esac

eval $finalCommand

#$coreScriptDir/passwordClean.sh


[ -f "$tmpRuleFile" ] && rm "$tmpRuleFile"

#cat $md5ResultFile >> "$md5DataFile"














