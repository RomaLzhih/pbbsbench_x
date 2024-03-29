#!/bin/bash
# ./run_inba_ratio.sh
# ./run_highDim.sh

# PARLAY_NUM_THREADS=192 numactl -i all ../build/test -p /data3/zmen002/kdtree/geometry/OpenStreetMap.in -d 2 -r 1 -t 0 -i 0 -q 1 >"test.out"
# PARLAY_NUM_THREADS=192 numactl -i all ../build/cgal -p /data3/zmen002/kdtree/geometry/OpenStreetMap.in -d 2 -r 1 -t 0 -i 0 -q 1 >"cgal.out"

# perf stat -e cache-misses ./test -p /localdata/zmen002/kdtree/ss_varden/10000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0
# perf stat -e cache-misses ./test -p /localdata/zmen002/kdtree/ss_varden/20000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0
# perf stat -e cache-misses ./test -p /localdata/zmen002/kdtree/ss_varden/50000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0
# perf stat -e cache-misses ./test -p /localdata/zmen002/kdtree/ss_varden/100000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0

mem_file=("test_mem.out","test_mem.out","test_mem.out","test_mem.out")
valgrind --tool=massif --time-unit=B --massif-out-file=test_mem.out ./../build/test -p /localdata/zmen002/kdtree/ss_varden/10000000_3/1.in -d 3 -k 10 -t 0 -q 0 -i 0
ms_print test_mem.out
