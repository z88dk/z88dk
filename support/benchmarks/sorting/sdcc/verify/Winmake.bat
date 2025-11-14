sdasz80 -g -o crt0.s
sdasz80 -g -o cpm.s
sdcc -c -mz80 --max-allocs-per-node200000 qsort.c
sdcc -c -mz80 -DPRINTF -DSTYLE=0 -DNUM=20 --max-allocs-per-node200000 sort.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel qsort.rel sort.rel -o sort-ran-20.ihx
hex2bin sort-ran-20.ihx
copy /b sort-ran-20.bin sr20.com
sdcc -c -mz80 -DPRINTF -DSTYLE=1 -DNUM=20 --max-allocs-per-node200000 sort.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel qsort.rel sort.rel -o sort-ord-20.ihx
hex2bin sort-ord-20.ihx
copy /b sort-ord-20.bin so20.com
sdcc -c -mz80 -DPRINTF -DSTYLE=2 -DNUM=20 --max-allocs-per-node200000 sort.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel qsort.rel sort.rel -o sort-rev-20.ihx
hex2bin sort-rev-20.ihx
copy /b sort-rev-20.bin sv20.com
sdcc -c -mz80 -DPRINTF -DSTYLE=3 -DNUM=20 --max-allocs-per-node200000 sort.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel qsort.rel sort.rel -o sort-equ-20.ihx
hex2bin sort-equ-20.ihx
copy /b sort-equ-20.bin se20.com
sdcc -c -mz80 -DPRINTF -DSTYLE=0 -DNUM=5000 --max-allocs-per-node200000 sort.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel qsort.rel sort.rel -o sort-ran-5000.ihx
hex2bin sort-ran-5000.ihx
copy /b sort-ran-5000.bin sr5000.com
sdcc -c -mz80 -DPRINTF -DSTYLE=1 -DNUM=5000 --max-allocs-per-node200000 sort.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel qsort.rel sort.rel -o sort-ord-5000.ihx
hex2bin sort-ord-5000.ihx
copy /b sort-ord-5000.bin so5000.com
sdcc -c -mz80 -DPRINTF -DSTYLE=2 -DNUM=5000 --max-allocs-per-node200000 sort.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel qsort.rel sort.rel -o sort-rev-5000.ihx
hex2bin sort-rev-5000.ihx
copy /b sort-rev-5000.bin sv5000.com
sdcc -c -mz80 -DPRINTF -DSTYLE=3 -DNUM=5000 --max-allocs-per-node200000 sort.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel qsort.rel sort.rel -o sort-equ-5000.ihx
hex2bin sort-equ-5000.ihx
copy /b sort-equ-5000.bin se5000.com
