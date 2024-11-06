#!/bin/bash

if ! command -v stress-ng &> /dev/null; then
    echo "Error: stress-ng is not installed" >&2
    exit 1
fi

CORE_COUNT=$(($(nproc)))

stress-ng --cpu $CORE_COUNT --cpu-method all --verify -t 20m --perf > test.txt &

turbostat --Summary --show Busy,Bzy_MHz,PkgWatt,PkgTemp --interval 5
