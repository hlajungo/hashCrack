# hashCracker
# Current supported hash type
md5, md5crypt, bcrypt

## The target of project
- classified hash data

- manage dict
- manage rule
- create dict
- preprocess dict
- run hashcat

## dependence
pack - This is included.
hashcat -
## project tree
├── bin      
├── config      
├── data        # The place that data will stroage for long time.
├── makefile
├── output.txt  # The place of 
├── pack-master  # Third party script.
├── README.md
├── script    
├── src      
└── temp    # The place that temp data will storage, everything in here is deleteable.

## script usage
- hashSplitter.sh  
Split mixed hash type archives into one file for each hash.
Input: IhashesFile
Outpu: splitHashDir

- hash5Cracker.sh 
The script to crack hash,



- fileMerger.sh   
Merge the file with format time:hash:password, which is our result in data file.

Input: $@
Outpu: outputFile

- maskGenerator.sh  
Use pack/maskgen.py and password to generate mask,not that automated.
exmaple
```
cut -f 3 -d ':' data/md5Data.txt   > temptemp
script/maskGenerator.sh temptemp
rm temptemp
```

Input: $1
Output: maskFile and console

- ruleGenerator.sh         
Use pack/rulegen.py and dict to generate rule.

Input: ruleGenerateTargetDictFile
Outpu: ruleFile and won't overwrite it

- ruleMerger.sh
Merge the rule and remove duplicates.
CPU parallel,you can set the cpu number in `config` file.
Input: IdictDir
Outpu: ruleFile and won't overwrite it


- dictProcessor.sh
Merge the dict, remove duplicates and duplicate it with rule.

Input: IdictDir
Outpu: preProcessedDictArray






















