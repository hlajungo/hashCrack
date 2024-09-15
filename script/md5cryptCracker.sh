#!/bin/bash
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/../config"

    #python2 statsgen.py $file -o temp.masks
    #python2 maskgen.py temp.masks --targettime 1200

    #-a 6 == mask+dict
    #-a 3 == mask

    #hashcat -a 3 -m 0 -w 3 -O -o $resultFile  --increment --increment-min=1 --increment-max=15 $hashes_file ?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?l?d

    hashcat -a 3 -m 500 \
    -w 3 -O \
    --session=md5cryptsession1 --restore-file-path="$restoreDir/md5cryptsession1" \
    -o $md5cryptResultFile --outfile-format=1,2,6 --outfile-check-timer=30 --potfile-path="$potFile" \
    --increment --increment-min=1 --increment-max=20 \
    $md5cryptFile \
    ?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1?1 -1 ?l?d




# hashcat --restore --session=md5session1 --restore-file-path="temp/restore/md5session1"

