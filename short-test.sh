stress-ng --cpu 32 --cpu-method all --verify -t 20m --perf > test.txt &
# might also do some --perf to get performance benchmarks out

turbostat --Summary --show Busy,Bzy_MHz,PkgWatt,PkgTemp --interval 5
