#!/bin/bash

SCRIPT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/../config"

echo "$(basename "$0") working start"


tmp1=$(mktemp)

for file in "${ruleGenerateTargetDictFile[@]}"; do
    cut -d":" -f 3 $file > $tmp1
    python "$IpackDir/rulegen.py" $tmp1 --morerules -b "$ruleDir/temp"
    cat "$ruleDir/temp-sorted.rule" >> $ruleFile
done

sort --parallel="$PARALLEL_JOBS" -S 50% -u "$ruleFile" > "$ruleFile.tmp" && mv "$ruleFile.tmp" "$ruleFile"

echo "have $(wc -l <$ruleFile) rules in  $ruleFile"

rm $tmp1

echo "$(basename "$0") working done"

