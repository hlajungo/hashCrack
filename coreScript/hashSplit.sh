#!/bin/bash

echo "$(basename "$0") working start"

show_version() {
    echo "$(basename "$0") 1.0"
}

show_help() {
    echo "Usage: $0 {splitDirPath}"
    echo ""
    echo "  -v, --version    version"
    echo "  --help           help"
}

# Non-argument
if [[ "$#" -eq 0 ]]; then
    show_help
fi

# Process the command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -v|--version)
            show_version
            exit 0
            ;;
        --help) 
            show_help
            exit 0
            ;;
        *) 
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done




while IFS= read -r hash; do
    if [[ "$hash" =~ ^[0-9a-fA-F]{32}$ ]]; then         # 0 md5
        echo "$hash" >> "$outputDir/0.hash"
    elif [[ "$hash" == \$1\$* ]]; then                  # 500 md5crypt
        echo "$hash" >> "$outputDir/500.hash"
    elif [[ "$hash" == \$2b\$* ]]; then                 # 3200 bcrypt
        echo "$hash" >> "$outputDir/3200.hash"
    else
        echo "[Error]: Unknown hash $hash"
    fi
done < "$IhashesFile"

echo "$(basename "$0") working done"
