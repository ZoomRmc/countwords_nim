#!/usr/bin/env bash

set -e

BIBLE=/tmp/kjvbible_x50.txt
if [ ! -f "$BIBLE" ]; then
    for i in {1..50}; do
        cat kjvbible.txt >>"$BIBLE"
    done  
fi

echo -Go optimized
echo --building...
go build -o optimized-go optimized.go
echo --running...
time ./optimized-go <"$BIBLE" >/dev/null
#git diff --exit-code output.txt

echo -Nim optimized
echo --building...
nim c --gc:arc -d:danger --passC:"-flto" --passL:"-flto" -o:optimized_nim optimized.nim
echo --running...
time ./optimized_nim <"$BIBLE" >/dev/null
#git diff --exit-code output.txt
