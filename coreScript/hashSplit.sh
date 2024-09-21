#!/bin/bash


showVersion() {
	echo "$(basename "$0") 1.0"
}

showHelp() {
	echo "Split mixed hash files, currently only supports md5 md5crypt bcrypt"
	echo ""
	echo "Usage: $(basename "$0") [options]... hashesFile"
	echo ""
	echo "Options:"
	echo "  -v, --version    Show version"
	echo "  -h, --help       Show help"
	echo "  --output-dir     Specifies the output directory. Defaults to 'hashSplit'."
	echo ""
}

# arguments setting
ARGS=$(getopt -o \
hv\
\
\
 --long \
help,version,\
\
output-dir::\
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
	--output-dir)
		mkdir -p "$2"
		outputDir="$2"
		outputDirFlag=1
		shift 2
		;;
	--)
		shift
		break
		;;
	*)
		echo "Internal error!"
		exit 1
		;;
	esac
done

# hashes file
if [[ -z "$1" ]]; then
	showHelp
	exit 1
elif [[ ! -f "$1"  ]]; then
	echo "Error: '$1' is not a file"
	exit 1
fi

echo "$(basename "$0") start"

# output file
if [[ $outputDirFlag -ne 1 ]]; then
	outputDir="hashSplit"
	mkdir -p "hashSplit"
fi


>"$outputDir/0.hash"
>"$outputDir/500.hash"
>"$outputDir/3200.hash"
while IFS= read -r hash; do
	if [[ "$hash" =~ ^[0-9a-fA-F]{32}$ ]]; then # 0 md5
		echo "$hash" >>"$outputDir/0.hash"
	elif [[ "$hash" == \$1\$* ]]; then # 500 md5crypt
		echo "$hash" >>"$outputDir/500.hash"
	elif [[ "$hash" == \$2b\$* ]]; then # 3200 bcrypt
		echo "$hash" >>"$outputDir/3200.hash"
	else
		echo "[Error]: Unknown hash '$hash'"
	fi
done <"$1"

echo "$(basename "$0") done"
