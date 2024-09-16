#!/bin/bash

source "config"

if [ ! -f "$IhashesFile" ]; then
    echo "[Error]: $IhashesFile not found."
    exit 1
fi

if [ ! -d "$IdictDir" ]; then
    echo "[Error]: $IdictDir not found."
    exit 1
fi

mkdir -p "split_hash"
> "$md5_file"
> "$md5crypt_file"
> "$bcrypt_file"

current_time=$(date +"%Y%m%d%H%M")

rootDir="/home/hlajungo/hipac3DataAll/hipac3data/hash/myTestSpace/new/hashCracker"
DICT_MIN_LENGTH=1    #[1,inf]


dictDir="$rootDir/dict"
ruleDir="$rootDir/rule"
tempDir="$rootDir/temp"
dataDir="$rootDir/data"

mkdir -p $dictDir
mkdir -p $ruleDir
mkdir -p $tempDir
mkdir -p $dataDir

splitHashDir="$tempDir/splitHash"
restoreDir="$tempDir/restore"
mkdir -p $splitHashDir

maskFile="$tempDir/temp.masks"
potFile="$tempDir/temp.pot"
tempDictFile="$tempDir/temp.dict"

touch $potFile

md5File="$splitHashDir/md5_hashes.txt"
md5cryptFile="$splitHashDir/md5crypt_hashes.txt"
bcryptFile="$splitHashDir/bcrypt_hashes.txt"


resultDir="$tempDir/result"
md5ResultFile="$resultDir/md5Result.txt" #the file must be existed
md5cryptResultFile="$resultDir/md5cryptResult.txt"
bcryptResultFile="$resultDir/bcryptResult.txt"


outputFile="$rootDir/output.txt"
