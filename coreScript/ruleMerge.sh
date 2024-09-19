#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/../config"

echo "$(basename "$0") working start"

for dir in "${IruleDir[@]}"; do
  if [[ ! -d "$dir" && ! -f "$dir" ]]; then
    echo "[Error]: $0 $dir doesn't exist."
    exit 1
  fi
done

for dir in "${IruleDir[@]}"; do
    echo "Using $dir"
    find "$dir" -type f -name "*.rule" -exec cat {} >> "$ruleFile" \;
done

sort --parallel="$PARALLEL_JOBS" -S 50% -u "$ruleFile" > "$ruleFile.tmp" && mv "$ruleFile.tmp" "$ruleFile"

echo "have $(wc -l <$ruleFile) rules in  $ruleFile ."

echo "$(basename "$0") working done"

