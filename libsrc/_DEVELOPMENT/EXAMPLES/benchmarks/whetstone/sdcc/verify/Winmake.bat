sdasz80 -g -o crt0.s
sdasz80 -g -o cpm.s
sdcc -c -mz80 -DUSE_FLOATS printf_large.c
sdcc -c -mz80 -DPRINTOUT --max-allocs-per-node200000 whetstone.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel printf_large.rel whetstone.rel -o whetstone.ihx
hex2bin whetstone.ihx
copy /b whetsone.bin whetston.com
