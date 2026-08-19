include ../make.config

all: stitch_z80.ok stitch_8085.ok stitch_z80.bin.ok stitch_z80_verbose.ok helpers.ok optimiser.ok

stitch_z80.ok: twofuncs.c
	zcc +test -vn -a -compiler=multi -compiler-multi-report=z80.tsv twofuncs.c
	test -f twofuncs.c.asm
	grep -q 'zcc-multi: metric=ticks' twofuncs.c.asm
	test `grep -c '^\._foo$$' twofuncs.c.asm` -eq 1
	test `grep -c '^\._bar$$' twofuncs.c.asm` -eq 1
	test `grep -c '^\._g' twofuncs.c.asm` -eq 1
	grep -q '^_foo	' z80.tsv
	grep -q '^_bar	' z80.tsv
	touch $@

stitch_8085.ok: twofuncs.c
	zcc +test -vn -clib=8085 -a -compiler=multi -compiler-multi-report=8085.tsv twofuncs.c
	test -f twofuncs.c.asm
	test `grep -c '80cc-fp' 8085.tsv` -eq 0
	test `grep -c '^\._foo$$' twofuncs.c.asm` -eq 1
	touch $@

stitch_z80.bin.ok: twofuncs.c
	zcc +test -vn -compiler=multi twofuncs.c -o twofuncs.bin -m
	test -f twofuncs.bin
	touch $@

stitch_z80_verbose.ok: twofuncs.c
	zcc +test -v -a -compiler=multi -compiler-multi-report=verbose.tsv twofuncs.c 2>verbose.err
	grep -q 'zcc-multi-summary: file=' verbose.err
	grep -q 'zcc-multi-summary: selected' verbose.err
	grep -q 'zcc-multi-summary: share' verbose.err
	grep -q '^summary$$' verbose.tsv
	touch $@

helpers.ok: helpers.c
	zcc +test -vn -a -compiler=multi -compiler-multi-report=helpers.tsv helpers.c
	grep -q '^_sum	' helpers.tsv
	test `grep -c '^\._sum$$' helpers.c.asm` -eq 1
	touch $@

# Discarded sccz80 body must not leave copt "defc i_N = i_M" in the stitch.
OPT_SCCZ80 = ../../../src/zcc-multi/t/opt_sccz80.asm
OPT_80CC = ../../../src/zcc-multi/t/opt_80cc.asm

optimiser.ok: $(OPT_SCCZ80) $(OPT_80CC)
	z88dk-zcc-multi --cpu=z80 --metric=size --data-variant=sccz80 \
	  --output=opt_stitch.asm \
	  --variant=sccz80:$(OPT_SCCZ80) --variant=80cc-sp:$(OPT_80CC)
	test `grep -c '^\._foo$$' opt_stitch.asm` -eq 1
	test `grep -c '^\._bar$$' opt_stitch.asm` -eq 1
	test `grep -c 'i_10_sccz80' opt_stitch.asm` -eq 0
	test `grep -c 'defc' opt_stitch.asm` -eq 0
	z88dk-z80asm -mz80 -oopt_stitch.bin opt_stitch.asm
	touch $@

clean:
	$(RM) *.ok *.asm *.o *.bin *.map *.tsv *.lis *.sym *.err twofuncs twofuncs.bin

.PHONY: all clean
