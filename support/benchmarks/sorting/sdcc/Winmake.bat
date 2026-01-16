sdcc -c -mz80 --max-allocs-per-node200000 qsort.c
sdcc -c -mz80 -DTIMER -DSTYLE=0 -DNUM=20 --max-allocs-per-node200000 sort.c
copy sort.sym sort-ran-20.sym
sdcc -mz80 qsort.rel sort.rel -o sort-ran-20.ihx
hex2bin sort-ran-20.ihx
sdcc -c -mz80 -DTIMER -DSTYLE=1 -DNUM=20 --max-allocs-per-node200000 sort.c
copy sort.sym sort-ord-20.sym
sdcc -mz80 qsort.rel sort.rel -o sort-ord-20.ihx
hex2bin sort-ord-20.ihx
sdcc -c -mz80 -DTIMER -DSTYLE=2 -DNUM=20 --max-allocs-per-node200000 sort.c
copy sort.sym sort-rev-20.sym
sdcc -mz80 qsort.rel sort.rel -o sort-rev-20.ihx
hex2bin sort-rev-20.ihx
sdcc -c -mz80 -DTIMER -DSTYLE=3 -DNUM=20 --max-allocs-per-node200000 sort.c
copy sort.sym sort-equ-20.sym
sdcc -mz80 qsort.rel sort.rel -o sort-equ-20.ihx
hex2bin sort-equ-20.ihx
sdcc -c -mz80 -DTIMER -DSTYLE=0 -DNUM=5000 --max-allocs-per-node200000 sort.c
copy sort.sym sort-ran-5000.sym
sdcc -mz80 qsort.rel sort.rel -o sort-ran-5000.ihx
hex2bin sort-ran-5000.ihx
sdcc -c -mz80 -DTIMER -DSTYLE=1 -DNUM=5000 --max-allocs-per-node200000 sort.c
copy sort.sym sort-ord-5000.sym
sdcc -mz80 qsort.rel sort.rel -o sort-ord-5000.ihx
hex2bin sort-ord-5000.ihx
sdcc -c -mz80 -DTIMER -DSTYLE=2 -DNUM=5000 --max-allocs-per-node200000 sort.c
copy sort.sym sort-rev-5000.sym
sdcc -mz80 qsort.rel sort.rel -o sort-rev-5000.ihx
hex2bin sort-rev-5000.ihx
sdcc -c -mz80 -DTIMER -DSTYLE=3 -DNUM=5000 --max-allocs-per-node200000 sort.c
copy sort.sym sort-equ-5000.sym
sdcc -mz80 qsort.rel sort.rel -o sort-equ-5000.ihx
hex2bin sort-equ-5000.ihx
