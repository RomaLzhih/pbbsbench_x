#!/bin/bash

# perf stat -e cache-misses ./../build/test -p /localdata/zmen002/kdtree/ss_varden/10000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0
# perf stat -e cache-misses ./../build/test -p /localdata/zmen002/kdtree/ss_varden/20000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0
# perf stat -e cache-misses ./../build/test -p /localdata/zmen002/kdtree/ss_varden/50000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0
# perf stat -e cache-misses ./../build/test -p /localdata/zmen002/kdtree/ss_varden/100000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0

# perf stat -e cache-misses ./../build/cgal -p /localdata/zmen002/kdtree/ss_varden/10000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0
# perf stat -e cache-misses ./../build/cgal -p /localdata/zmen002/kdtree/ss_varden/20000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0
# perf stat -e cache-misses ./../build/cgal -p /localdata/zmen002/kdtree/ss_varden/50000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0
# perf stat -e cache-misses ./../build/cgal -p /localdata/zmen002/kdtree/ss_varden/100000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0

# perf stat -e cache-misses ./../build/zdtree -p /localdata/zmen002/kdtree/ss_varden/10000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0
# perf stat -e cache-misses ./../build/zdtree -p /localdata/zmen002/kdtree/ss_varden/20000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0
# perf stat -e cache-misses ./../build/zdtree -p /localdata/zmen002/kdtree/ss_varden/50000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0
# perf stat -e cache-misses ./../build/zdtree -p /localdata/zmen002/kdtree/ss_varden/100000000_3/1.in -d 3 -t 0 -q 0 -r 1 -i 0

# data_file=("10000000_3" "20000000_3" "50000000_3" "100000000_3")
# mem_file=("test_mem_100.out" "test_mem_200.out" "test_mem_500.out" "test_mem_1000.out")
# mem_parse_file=("test_mem_100_parse.out" "test_mem_200_parse.out" "test_mem_500_parse.out" "test_mem_1000_parse.out")
#
# for i in 0 1 2 3; do
# 	valgrind --tool=massif --time-unit=B --massif-out-file=perf_log/${mem_file[${i}]} --detailed-freq=1 ./../build/test -p /localdata/zmen002/kdtree/ss_varden/${data_file[${i}]}/1.in -d 3 -k 10 -t 0 -q 0 -i 0
# 	ms_print perf_log/${mem_file[${i}]} >"perf_log/${mem_parse_file[${i}]}"
# done

# data_file=("10000000_3" "20000000_3" "50000000_3" "100000000_3")
# mem_file=("cgal_mem_100.out" "cgal_mem_200.out" "cgal_mem_500.out" "cgal_mem_1000.out")
# mem_parse_file=("cgal_mem_100_parse.out" "cgal_mem_200_parse.out" "cgal_mem_500_parse.out" "cgal_mem_1000_parse.out")
#
# for i in 0 1 2 3; do
# 	valgrind --tool=massif --time-unit=B --massif-out-file=perf_log/${mem_file[${i}]} ./../build/cgal -p /localdata/zmen002/kdtree/ss_varden/${data_file[${i}]}/1.in -d 3 -k 10 -t 0 -q 0 -i 0
# 	ms_print perf_log/${mem_file[${i}]} >"perf_log/${mem_parse_file[${i}]}"
# done

data_file=("10000000_3" "20000000_3" "50000000_3" "100000000_3")
mem_file=("zdtree_mem_100.out" "zdtree_mem_200.out" "zdtree_mem_500.out" "zdtree_mem_1000.out")
mem_parse_file=("zdtree_mem_100_parse.out" "zdtree_mem_200_parse.out" "zdtree_mem_500_parse.out" "zdtree_mem_1000_parse.out")

for i in 0 1 2 3; do
	valgrind --tool=massif --time-unit=B --massif-out-file=perf_log/${mem_file[${i}]} --detailed-freq=10 ./../build/zdtree -p /localdata/zmen002/kdtree/ss_varden/${data_file[${i}]}/1.in -d 3 -k 10 -t 0 -q 0 -i 0
	ms_print perf_log/${mem_file[${i}]} >"perf_log/${mem_parse_file[${i}]}"
done
