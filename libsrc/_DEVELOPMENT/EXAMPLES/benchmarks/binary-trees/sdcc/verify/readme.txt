sdasz80 -g -o crt0.s
sdasz80 -g -o heap.s
sdasz80 -g -o cpm.s
sdcc -c -mz80 -DSTATIC -DPRINTF -DTIMER --max-allocs-per-node200000 binary-trees.c
sdcc -mz80 --no-std-crt0 crt0.rel heap.rel cpm.rel binary-trees.rel -o bt.ihx
.\hex2bin bt.ihx
copy /b bt.bin bt.com
