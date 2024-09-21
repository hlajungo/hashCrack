#!/bin/bash

debug() {
    if [ "$DEBUG" -eq 1 ]; then
        echo "DEBUG: $*"
    fi
}

showVersion() {
	echo "$(basename "$0") 1.0"
}

showHelp() {
    local outputStream=$1
eval echo "" $outputStream
eval echo "Merge input file and remove duplicates, if input is a dir, all file under it will be use " $outputStream
eval echo "" $outputStream
eval echo "Usage: $(basename "$0") [options]... file1 file2 dir1 dir2 ... > outputfile" $outputStream
eval echo "" $outputStream
eval echo "Options:" $outputStream
eval echo "  -v, --version    Show version" $outputStream
eval echo "  -h, --help       Show help" $outputStream
eval echo "  -p, --parallel=N   Set parallel core number" $outputStream
eval echo "" $outputStream
}

# arguments setting
ARGS=$(getopt -o \
hv\
p:\
\
 --long \
help,version,\
parallel:\
\
 -n $(basename "$0") -- "$@")

eval set -- "$ARGS"

while true; do
	case "$1" in
	-h | --help)
		showHelp
		exit 0
		;;
	-v | --version)
		showVersion
		exit 0
		;;
  -p | --parallel)
    CORE_NUM="$2"
    shift 2
    ;;
	--)
		shift
		break
		;;
	*)
		echo "Internal error!" >&2
		exit 1
		;;
	esac
done

if [[ -z "$1" ]]; then
	showHelp ">&2"
	exit 1
fi

for dir in "$@"; do
  if [[ ! -d "$dir" && ! -f "$dir" ]]; then
    echo "[Error]: $0 $dir doesn't exist." >&2
    exit 1
  fi
done

## Starting script

tmpFile="$(basename "$0").tmp"
for dir in "$@"; do
  find "$dir" -type f -exec cat {} + >> "$tmpFile"
done

sort --parallel="${CORE_NUM:-1}" -S 50% -u "$tmpFile" > "$tmpFile.tmp"

cat "$tmpFile.tmp"

[ -f "$tmpFile.tmp" ] && rm "$tmpFile.tmp"
[ -f "$tmpFile" ] && rm "$tmpFile"




