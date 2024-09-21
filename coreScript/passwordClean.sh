#!/bin/bash

showVersion() {
	echo "$(basename "$0") 1.0"
}

showHelp() {
    local outputStream=$1
printf "%s\n" "" $outputStream
printf "%s\n" "Clean up data in the format of 1:2:3 and check whether there are duplicates in the 2:3 part"\
 $outputStream
printf "%s\n" ""\
 $outputStream
printf "%s\n" "Usage: $(basename "$0") [options]... password > outputfile"\
 $outputStream
printf "%s\n" "" \
 $outputStream
printf "%s\n" "Options:"\
 $outputStream
printf "%s\n" "-v, --version    Show version"\
 $outputStream
printf "%s\n" "-h, --help       Show help"\
 $outputStream
printf "%s\n" ""\
 $outputStream

}

# arguments setting
ARGS=$(getopt -o \
hv\
\
\
 --long \
help,version,\
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

# hashes file
if [[ -z "$1" ]]; then
	showHelp >&2
	exit 1
elif [[ ! -f "$1"  ]]; then
	echo "Error: '$1' is not a file" >&2
	exit 1
fi



cut -f2,3 -d ":" "$1" > "${1}.tmp" #tmp 1:2:3 -> 2:3
cut -f1 -d ":" "$1" > "${1}.tmp2" #tmp2 1:2:3 -> 1
awk '!seen[$0]++ { print } seen[$0] == 2 { print "PLACEHOLDER_ROW" }' "$1.tmp" > "${1}.tmp3" #tmp2 2:3 with place holder
paste -d ":" "$1.tmp2" "$1.tmp3" > "$1.tmp"
echo "$(grep -v "PLACEHOLDER_ROW" "$1.tmp")"

[ -f "$1.tmp" ] && rm "$1.tmp"
[ -f "$1.tmp2" ] && rm "$1.tmp2"
[ -f "$1.tmp3" ] && rm "$1.tmp3"


