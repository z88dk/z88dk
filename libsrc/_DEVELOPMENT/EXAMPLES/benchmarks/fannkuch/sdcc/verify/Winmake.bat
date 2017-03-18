sdasz80 -g -o crt0.s
sdasz80 -g -o cpm.s
sdcc -c -mz80 -DSTATIC -DPRINTF -DINLINE --max-allocs-per-node200000 fannkuch.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel fannkuch.rel -o fannkuch.ihx
hex2bin fannkuch.ihx
copy /b fannkuch.bin fannkuch.com
