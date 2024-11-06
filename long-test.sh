#!/bin/bash

if ! command -v stress-ng &> /dev/null; then
    echo "Error: stress-ng is not installed" >&2
    exit 1
fi

CORE_COUNT=$(($(nproc)))

echo "Testing CPU cores and cache"
stress-ng --cpu $CORE_COUNT --cpu-method all --verify -t 1h

echo "Testing RAM and CPU interaction"
stress-ng --cpu $CORE_COUNT --vm 4 --vm-bytes 75% --verify -t 1h

echo "Testing CPU linear algebra instruction sets"
stress-ng --cpu $CORE_COUNT --cpu-method ackermann -t 20m
stress-ng --cpu $CORE_COUNT --cpu-method fft -t 20m
stress-ng --cpu $CORE_COUNT --cpu-method matrixprod -t 20m

echo "Testing CPU performance under a mixed workload"
stress-ng --cpu $CORE_COUNT --cpu-method all --vm 4 --vm-bytes 50% --cache 4 --iomix 4 --verify -t 1h

echo "All-out slog to the finish"
stress-ng --all 4 --maximize --verify -t 4h
