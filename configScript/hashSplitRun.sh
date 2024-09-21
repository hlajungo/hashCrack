#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/../config"

$coreScriptDir/hashSplit.sh --output-dir=$splitHashDir $IhashFile

