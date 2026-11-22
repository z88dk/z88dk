sdasz80 -g -o crt0.s
sdasz80 -g -o cpm.s
sdcc -c -mz80 -DPRINTF --max-allocs-per-node200000 fasta.c
sdcc -mz80 --no-std-crt0 crt0.rel cpm.rel fasta.rel -o fasta.ihx
hex2bin fasta.ihx
copy /b fasta.bin fasta.com
