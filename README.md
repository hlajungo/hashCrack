# hashCracker
## Current supported hash type
md5, md5crypt, bcrypt

## How to start?
1. Get hashcat
2. Set env variable

Verify by `which hashcat`

Result `/media/hlajungo/D/linux/repo/hashcat-6.2.6/hashcat`

3. cd to a nice place , like `/media/hlajungo/D/linux/repo`
4. `git clone https://github.com/hlajungo/hashCrack.git`
5. `cd hashCrack/`
6. Set your hash file`vim config`

Change `IhashFile` to your hash file, like `IhashFile="/media/hlajungo/D/linux/hash/question.txt"`

7. :wq and Split mixed hash `configScript/hashSplitRun.sh`

Verify result `tree temp/`
```
└── splitHash
    ├── 0.hash
    ├── 3200.hash
    └── 500.hash
```
Verify result `tail -n 5 temp/splitHash/0.hash`
```
81d3493809e9082d57e20f2052527350
f64864d02fe3219a8744debe6c047744
d1178b83096bcc14a56b66aa73506537
271de483f529793f871ee575fd86c639
92ac9b48e2c6161b6ad9c5b7d29e1794
```
8. Starting set up crack hash `vim configScript/hashCrackRun.sh`

8.1 Set hash type, there are 3 options, by comment them out to choose, md5(0) is recommend
```
hashFile="$splitHashDir/0.hash"
hashType="0"
data0File="${dataDir}/cracked0"

#hashFile="$splitHashDir/500.hash"
#hashType="500"
#data0File="${dataDir}/cracked500"

#hashFile="$splitHashDir/3200.hash"
#hashType="3200"
#data0File="${dataDir}/cracked3200"
```
8.2 Find variable `controler` set to `000`, this will set brute-force mode.

8.3 :wq and run `configScript/hashCrackRun.sh`
It should working,output like below
```
Session..........: 1
Status...........: Running
Hash.Mode........: 0 (MD5)
Hash.Target......: /media/hlajungo/D/linux/repo/hashCrack/temp/splitHash/0.hash
Time.Started.....: Sun Sep 22 01:24:23 2024 (8 secs)
Time.Estimated...: Sun Sep 22 01:25:34 2024 (1 min, 3 secs; Runtime limited: 29 mins, 52 secs)
Kernel.Feature...: Optimized Kernel
Guess.Mask.......: ?a?a?a?a?a?a [6]
Guess.Queue......: 6/25 (24.00%)
Speed.#1.........: 10277.0 MH/s (71.94ms) @ Accel:64 Loops:95 Thr:1024 Vec:8
Recovered........: 112/481 (23.28%) Digests (total), 112/481 (23.28%) Digests (new)
Progress.........: 80654106624/735091890625 (10.97%)
Rejected.........: 0/80654106624 (0.00%)
Restore.Point....: 6029312/81450625 (7.40%)
Restore.Sub.#1...: Salt:0 Amplifier:8704-8960 Iteration:0-256
Candidate.Engine.: Device Generator
Candidates.#1....: #`OTOM -> y~WOk2
Hardware.Mon.#1..: Temp: 51c Util: 98% Core: 735MHz Mem:7000MHz Bus:8
```
`s` to check status, You can keep pressing it , and be careful with `q`, this mean quit.

8.4 Great, there other mode in `configScript/hashCrackRun.sh` to enable dict. mask, rule attack, but skipped at here.After cracking it, you have to merge them.

Run `coreScript/fileMerge.sh data/cracked0 `, if you have other file in `data/`, do like this `coreScript/fileMerge.sh data/cracked0 data/cracked500 data/cracked3200`

Verify result `vim output.txt` and `/:` to search `:`, something like  `6b3bee951d5ef1277c80c6c5a5830e41:*MOe"` should happen, that mean that hash is cracked, great.   







