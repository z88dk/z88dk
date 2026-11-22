sdasz80 -g -o crt0.s
sdasz80 -g -o cpm.s
sdcc -c -mz80 -DUSE_FLOATS printf_large.c
sdcc -c -mz80 -DSTATIC -DPRINTF --max-allocs-per-node200000 n-body.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel printf_large.rel n-body.rel -o n-body.ihx
hex2bin n-body.ihx
copy /b n-body.bin n-body.com
