#!/bin/bash

LOG_FILE="./logs-core-cycler.log"
PROGRESS_FILE="./temp-core-cycler-progress"

# 40m and 10m should work
LONG_TEST_LEN="5m"
SHORT_TEST_LEN="1m"

GREEN='\033[0;32m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m'

MAX_CORES=$(($(nproc) - 1))

log_message() {
    local level=$1
    local message=$2
    local to_file=$3
    local color=""
    
    case $level in
        "PASS") color=$GREEN ;;
        "FAIL") color=$RED ;;
        "INFO") color=$ORANGE ;;
    esac
    
    timestamp=$(date '+%Y-%m-%d %H:%M')
    local timestamp

    formatted_message="$timestamp [${level}] ${message}"
    local formatted_message

    if [ "$to_file" = "true" ]; then
        echo "$formatted_message" >> "$LOG_FILE"
    fi
    
    echo -e "$timestamp [${color}${level}${NC}] ${message}"
}

if [ "$EUID" -ne 0 ]; then
    log_message "FAIL" "This script must be run with sudo/root privileges" "true"
    exit 1
fi

if ! command -v stress-ng &> /dev/null; then
    log_message "FAIL" "stress-ng is not installed" >&2
    exit 1
fi

cleanup() {
    log_message "INFO" "Interrupted by user. Cleaning up..." "true"
    rm -f "$PROGRESS_FILE"
    exit 1
}

trap cleanup SIGINT

log_message "INFO" "Starting core cycling tests" "true" > "$LOG_FILE"

run_core_tests() {
    local core=$1
    log_message "INFO" "=== Testing core $core ===" "true"
    
    echo "$core" > "$PROGRESS_FILE"
    
    log_message "INFO" "Testing CPU cores and cache on core $core" "true"
    if stress-ng --taskset "$core" --cpu 1 --cpu-method all --verify -t "$LONG_TEST_LEN"; then
        log_message "PASS" "Core $core: Basic CPU test" "true"
    else
        log_message "FAIL" "Core $core: Basic CPU test" "true"
        return 1
    fi

    log_message "INFO" "Testing CPU linear algebra on core $core" "true"
    for method in ackermann fft matrixprod; do
        if stress-ng --taskset "$core" --cpu 1 --cpu-method $method -t "$SHORT_TEST_LEN"; then
            log_message "PASS" "Core $core: $method test" "true"
        else
            log_message "FAIL" "Core $core: $method test" "true"
            return 1
        fi
    done

    log_message "INFO" "Testing mixed workload on core $core" "true"
    if stress-ng --taskset "$core" --cpu 1 --vm 4 --vm-bytes 50% --cache 4 --cache-enable-all --iomix 4 --verify -t "$LONG_TEST_LEN"; then
        log_message "PASS" "Core $core: Mixed workload test" "true"
    else
        log_message "FAIL" "Core $core: Mixed workload test" "true"
        return 1
    fi

    log_message "INFO" "Running maximum stress on core $core" "true"
    if stress-ng --taskset "$core" --cpu 1 --maximize --cache-enable-all --verify -t "$LONG_TEST_LEN"; then
        log_message "PASS" "Core $core: Maximum stress test" "true"
    else
        log_message "FAIL" "Core $core: Maximum stress test" "true"
        return 1
    fi

    return 0
}

LAST_CORE=-1
[ -f "$PROGRESS_FILE" ] && LAST_CORE=$(cat "$PROGRESS_FILE")

for core in $(seq 0 $MAX_CORES); do
    if [ "$core" -le "$LAST_CORE" ]; then
        continue
    fi
    
    log_message "INFO" "Starting tests for core $core" "true"
    if run_core_tests "$core"; then
        log_message "PASS" "Completed all tests for core $core successfully" "true"
    else
        log_message "FAIL" "Tests failed for core $core" "true"
    fi
done

rm -f "$PROGRESS_FILE"
log_message "INFO" "All core tests completed" "true"
