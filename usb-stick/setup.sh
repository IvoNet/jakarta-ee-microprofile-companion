#!/bin/sh
exec 2>&1
for script in retrieve_*.sh
do
    echo "===================================================================="
    echo "== Executing script: ${script}"
    echo "===================================================================="
    . ./"${script}";
done
