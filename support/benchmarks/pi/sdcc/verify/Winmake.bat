sdasz80 -g -o crt0.s
sdasz80 -g -o cpm.s
sdcc -c -mz80 -DSTATIC -DPRINTF --max-allocs-per-node200000 pi.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel pi.rel -o pi.ihx
hex2bin pi.ihx
copy /b pi.bin pi.com
