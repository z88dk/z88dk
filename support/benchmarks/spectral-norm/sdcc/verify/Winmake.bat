sdasz80 -g -o crt0.s
sdasz80 -g -o cpm.s
sdcc -c -mz80 -DUSE_FLOATS printf_large.c
sdcc -c -mz80 -DSTATIC -DPRINTF --max-allocs-per-node200000 spectral-norm.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel printf_large.rel spectral-norm.rel -o spectral.ihx
hex2bin spectral.ihx
copy /b spectral.bin spectral.com
