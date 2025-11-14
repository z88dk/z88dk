sdasz80 -g -o crt0.s
sdasz80 -g -o cpm.s
sdcc -c -mz80 -DSTATIC -DPRINTF --max-allocs-per-node200000 sieve.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel sieve.rel -o sieve.ihx
hex2bin sieve.ihx
copy /b sieve.bin sieve.com
