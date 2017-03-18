sdasz80 -g -o heap.s
sdcc -c -mz80 -DSTATIC -DTIMER --max-allocs-per-node200000 binary-trees.c
sdcc -mz80 heap.rel binary-trees.rel -o bt.ihx
hex2bin bt.ihx
