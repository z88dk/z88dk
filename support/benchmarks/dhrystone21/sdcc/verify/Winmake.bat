sdasz80 -g -o crt0.s
sdasz80 -g -o cpm.s
sdcc -c -mz80 -DNOSTRUCTASSIGN -DPRINTF --max-allocs-per-node200000 dhry_1.c
sdcc -c -mz80 -DNOSTRUCTASSIGN -DPRINTF --max-allocs-per-node200000 dhry_2.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel dhry_1.rel dhry_2.rel -o dhry.ihx
hex2bin dhry.ihx
copy /b dhry.bin dhry.com
