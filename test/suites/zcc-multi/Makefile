include ../make.config

all: stitch_z80.ok stitch_8085.ok stitch_z80.bin.ok stitch_z80_verbose.ok helpers.ok optimiser.ok fallback.ok loopcount.ok loopzero.ok mul.ok ldir.ok ldimm.ok

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

# jp (hl) must not win on ticks; reason is fallback.
fallback.ok: ../../../src/zcc-multi/t/jp_hl.asm ../../../src/zcc-multi/t/jp_hl_alt.asm
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=fb_stitch.asm --report=fb.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/jp_hl.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/jp_hl_alt.asm
	grep -q 'fallback' fb.tsv
	touch $@

# ld b,8 / djnz must multiply the loop span.
loopcount.ok: ../../../src/zcc-multi/t/loop_count.asm ../../../src/zcc-multi/t/loop_once.asm
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=loop_stitch.asm --report=loop.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/loop_count.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/loop_once.asm
	test `awk -F'	' '/^_foo/ {print $$6}' loop.tsv` -gt 40
	touch $@

# ld b,0 is 256 trips; ld bc,0 with or-through-A is 65536.
# dec bc / jp nz without or is not a counted loop.
# 8085 jp nk after dec bc is a general 16-bit loop (any N, and 0 wraps).
loopzero.ok: ../../../src/zcc-multi/t/loop_b0.asm ../../../src/zcc-multi/t/loop_bc0.asm \
	../../../src/zcc-multi/t/loop_bc_nz.asm ../../../src/zcc-multi/t/loop_8085_k.asm \
	../../../src/zcc-multi/t/loop_8085_k0.asm ../../../src/zcc-multi/t/loop_once.asm
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=loop_b0_stitch.asm --report=loop_b0.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/loop_b0.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/loop_once.asm
	test `awk -F'	' '/^_foo/ {print $$6}' loop_b0.tsv` -gt 1000
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=loop_bc0_stitch.asm --report=loop_bc0.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/loop_bc0.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/loop_once.asm
	test `awk -F'	' '/^_foo/ {print $$6}' loop_bc0.tsv` -gt 100000
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=loop_bc_nz_stitch.asm --report=loop_bc_nz.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/loop_bc_nz.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/loop_once.asm
	test `awk -F'	' '/^_foo/ {print $$6}' loop_bc_nz.tsv` -lt 80
	z88dk-zcc-multi --cpu=8085 --metric=ticks --data-variant=sccz80 \
	  --output=loop_8085_k_stitch.asm --report=loop_8085_k.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/loop_8085_k.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/loop_once.asm
	test `awk -F'	' '/^_foo/ {print $$6}' loop_8085_k.tsv` -gt 40
	z88dk-zcc-multi --cpu=8085 --metric=ticks --data-variant=sccz80 \
	  --output=loop_8085_k0_stitch.asm --report=loop_8085_k0.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/loop_8085_k0.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/loop_once.asm
	test `awk -F'	' '/^_foo/ {print $$6}' loop_8085_k0.tsv` -gt 100000
	touch $@

# Shared l_mult cancels; scores are wrappers. Still must stitch and report.
mul.ok: mul.c
	zcc +test -vn -a -compiler=multi -compiler-multi-report=mul.tsv mul.c
	grep -q '^_mul	' mul.tsv
	test `grep -c '^\._mul$$' mul.c.asm` -eq 1
	touch $@

# ldir: ld bc,4 → 21*4; unknown BC → ZCCMULTI_BLOCK_REP (2) → 42.
ldir.ok: ../../../src/zcc-multi/t/ldir_bc.asm ../../../src/zcc-multi/t/ldir_unk.asm
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=ldir_bc_stitch.asm --report=ldir_bc.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/ldir_bc.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/ldir_bc.asm
	test `awk -F'	' '/^_foo/ {print $$6}' ldir_bc.tsv` -gt 70
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=ldir_unk_stitch.asm --report=ldir_unk.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/ldir_unk.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/ldir_unk.asm
	test `awk -F'	' '/^_foo/ {print $$6}' ldir_unk.tsv` -eq 52
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=ldir_bc0_stitch.asm --report=ldir_bc0.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/ldir_bc0.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/ldir_bc0.asm
	test `awk -F'	' '/^_foo/ {print $$6}' ldir_bc0.tsv` -gt 1000000
	touch $@

# Operand-based ticks: ld hl,1 is 10 T, not 4. nop+nop+ret (18) beats ld hl,1 / ret (20).
ldimm.ok: ../../../src/zcc-multi/t/ldimm.asm ../../../src/zcc-multi/t/nops.asm
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=ldimm_stitch.asm --report=ldimm.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/ldimm.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/nops.asm
	test `awk -F'	' '/^_foo/ {print $$6}' ldimm.tsv` -eq 20
	test `awk -F'	' '/^_foo/ {print $$7}' ldimm.tsv` -eq 18
	grep -q '^_foo	80cc-sp' ldimm.tsv
	touch $@

clean:
	$(RM) *.ok *.asm *.o *.bin *.map *.tsv *.lis *.sym *.err twofuncs twofuncs.bin fb_stitch.asm loop_stitch.asm loop_b0_stitch.asm loop_bc0_stitch.asm loop_bc_nz_stitch.asm loop_8085_k_stitch.asm loop_8085_k0_stitch.asm ldir_bc0_stitch.asm ldimm_stitch.asm

.PHONY: all clean
