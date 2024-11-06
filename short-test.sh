#!/bin/bash

stress-ng --cpu 32 --cpu-method all --verify -t 20m --perf > test.txt &

turbostat --Summary --show Busy,Bzy_MHz,PkgWatt,PkgTemp --interval 5
