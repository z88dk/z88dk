sdasz80 -g -o crt0.s
sdasz80 -g -o cpm.s
sdasz80 -g -o heap.s
sdcc -c -mz80 -DSTATIC -DPRINTF --max-allocs-per-node200000 binary-trees.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel heap.rel binary-trees.rel -o bt.ihx
hex2bin bt.ihx
copy /b bt.bin bt.com
