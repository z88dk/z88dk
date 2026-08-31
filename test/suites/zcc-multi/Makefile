include ../make.config

# zcc writes zcc_opt.def and <file>.c.asm in this directory. Parallel
# stitch_z80 / stitch_8085 / stitch_vm1 (and helpers/mul) race under MAKE_CONCURRENCY=-j.
.NOTPARALLEL:

all: stitch_z80.ok stitch_8085.ok stitch_vm1.ok stitch_z80.bin.ok stitch_z80_verbose.ok helpers.ok optimiser.ok fallback.ok mixfb.ok only.ok loopcount.ok loopzero.ok mul.ok ldir.ok ldimm.ok srahl.ok r2ka.ok ixword.ok iy.ok ext8085.ok extvm1.ok extgbz80.ok gbz80ex.ok extz180.ok extz80n.ok sdcc_abi.ok

stitch_z80.ok: twofuncs.c
	zcc +test -vn -a -compiler=multi --multi-compiler-report=z80.tsv twofuncs.c
	test -f twofuncs.c.asm
	grep -q 'zcc-multi: metric=ticks' twofuncs.c.asm
	test `grep -c '^\._foo$$' twofuncs.c.asm` -eq 1
	test `grep -c '^\._bar$$' twofuncs.c.asm` -eq 1
	test `grep -c '^\._g' twofuncs.c.asm` -eq 1
	grep -q '^_foo	' z80.tsv
	grep -q '^_bar	' z80.tsv
	touch $@

stitch_8085.ok: twofuncs.c
	zcc +test -vn -clib=8085 -a -compiler=multi --multi-compiler-report=8085.tsv twofuncs.c
	test -f twofuncs.c.asm
	test `grep -c '80cc-fp' 8085.tsv` -eq 0
	test `grep -c '^\._foo$$' twofuncs.c.asm` -eq 1
	touch $@

stitch_vm1.ok: twofuncs.c
	zcc +test -vn -clib=vm1 -a -compiler=multi --multi-compiler-report=vm1.tsv twofuncs.c
	test -f twofuncs.c.asm
	test `grep -c '80cc-fp' vm1.tsv` -eq 0
	test `grep -c '^\._foo$$' twofuncs.c.asm` -eq 1
	touch $@

stitch_z80.bin.ok: twofuncs.c
	zcc +test -vn -compiler=multi twofuncs.c -o twofuncs.bin -m
	test -f twofuncs.bin
	touch $@

stitch_z80_verbose.ok: twofuncs.c
	zcc +test -v -a -compiler=multi --multi-compiler-report=verbose.tsv twofuncs.c 2>verbose.err
	grep -q 'zcc-multi-summary: file=' verbose.err
	grep -q 'zcc-multi-summary: selected' verbose.err
	grep -q 'zcc-multi-summary: share' verbose.err
	grep -q '^summary$$' verbose.tsv
	touch $@

helpers.ok: helpers.c
	zcc +test -vn -a -compiler=multi --multi-compiler-report=helpers.tsv helpers.c
	grep -q '^_sum	' helpers.tsv
	test `grep -c '^\._sum$$' helpers.c.asm` -eq 1
	touch $@

# Discarded sccz80 body must not leave copt "defc i_N = i_M" in the stitch.
OPT_SCCZ80 = ../../../src/zcc-multi/t/opt_sccz80.asm
OPT_80CC = ../../../src/zcc-multi/t/opt_80cc.asm
OPT_USED = ../../../src/zcc-multi/t/opt_used_sccz80.asm

optimiser.ok: $(OPT_SCCZ80) $(OPT_80CC) $(OPT_USED)
	z88dk-zcc-multi --cpu=z80 --metric=size --data-variant=sccz80 \
	  --output=opt_stitch.asm \
	  --variant=sccz80:$(OPT_SCCZ80) --variant=80cc-sp:$(OPT_80CC)
	test `grep -c '^\._foo$$' opt_stitch.asm` -eq 1
	test `grep -c '^\._bar$$' opt_stitch.asm` -eq 1
	test `grep -c 'i_10_sccz80' opt_stitch.asm` -eq 0
	test `grep -c 'defc' opt_stitch.asm` -eq 0
	z88dk-z80asm -mz80 -oopt_stitch.bin opt_stitch.asm
	z88dk-zcc-multi --cpu=z80 --metric=size --data-variant=sccz80 \
	  --output=opt_used.asm \
	  --variant=sccz80:$(OPT_USED) --variant=80cc-sp:$(OPT_80CC)
	grep -q 'i_10_sccz80' opt_used.asm
	z88dk-z80asm -mz80 -oopt_used.bin opt_used.asm
	touch $@

# jp (hl) must not win on ticks; reason is fallback.
fallback.ok: ../../../src/zcc-multi/t/jp_hl.asm ../../../src/zcc-multi/t/jp_hl_alt.asm
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=fb_stitch.asm --report=fb.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/jp_hl.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/jp_hl_alt.asm
	grep -q 'fallback' fb.tsv
	touch $@

# If any variant is unusable, pick by size among all bodies. Do not mix
# ticks of the usable pair with size of the fallback body.
mixfb.ok: ../../../src/zcc-multi/t/mix_small.asm \
	../../../src/zcc-multi/t/mix_fast.asm ../../../src/zcc-multi/t/mix_fb.asm
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=mixfb_stitch.asm --report=mixfb.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/mix_small.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/mix_fast.asm \
	  --variant=80cc-fp:../../../src/zcc-multi/t/mix_fb.asm
	test `awk '/^_foo/ {print $$3}' mixfb.tsv` = fallback
	grep -q '^_foo.sccz80' mixfb.tsv
	touch $@

# A function that exists in only one variant is still emitted.
only.ok: ../../../src/zcc-multi/t/only_two.asm ../../../src/zcc-multi/t/only_one.asm
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=only_stitch.asm --report=only.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/only_two.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/only_one.asm
	test `grep -c '^\._foo$$' only_stitch.asm` -eq 1
	test `grep -c '^\._bar$$' only_stitch.asm` -eq 1
	test `awk '/^_bar/ {print $$3}' only.tsv` = only
	grep -q '^_bar.sccz80' only.tsv
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
# VM1 jp of after dec bc is not: OF is not K.
loopzero.ok: ../../../src/zcc-multi/t/loop_b0.asm ../../../src/zcc-multi/t/loop_bc0.asm \
	../../../src/zcc-multi/t/loop_bc_nz.asm ../../../src/zcc-multi/t/loop_8085_k.asm \
	../../../src/zcc-multi/t/loop_8085_k0.asm ../../../src/zcc-multi/t/loop_vm1_of.asm \
	../../../src/zcc-multi/t/loop_once.asm
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
	z88dk-zcc-multi --cpu=vm1 --metric=ticks --data-variant=sccz80 \
	  --output=loop_vm1_of_stitch.asm --report=loop_vm1_of.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/loop_vm1_of.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/loop_once.asm
	test `awk -F'	' '/^_foo/ {print $$6}' loop_vm1_of.tsv` -lt 80
	touch $@

# Shared l_mult cancels; scores are wrappers. Still must stitch and report.
mul.ok: mul.c
	zcc +test -vn -a -compiler=multi --multi-compiler-report=mul.tsv mul.c
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
	z88dk-zcc-multi --cpu=gbz80 --metric=ticks --data-variant=sccz80 \
	  --output=ldir_gbz80_stitch.asm --report=ldir_gbz80.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/ldir_unk.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/ldir_unk.asm
	test `awk '/^_foo/ {print $$3}' ldir_gbz80.tsv` = metric
	test `awk -F'	' '/^_foo/ {print $$6}' ldir_gbz80.tsv` -eq 58
	touch $@

# Operand-based ticks: ld hl,1 is 10 T, not 4. nop+nop+ret (18) beats ld hl,1 / ret (20).
ldimm.ok: ../../../src/zcc-multi/t/ldimm.asm ../../../src/zcc-multi/t/nops.asm
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=ldimm_stitch.asm --report=ldimm.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/ldimm.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/nops.asm
	test `awk -F'	' '/^_foo/ {print $$6}' ldimm.tsv` -eq 20
	test `awk -F'	' '/^_foo/ {print $$7}' ldimm.tsv` -eq 18
	grep -q '^_foo.80cc-sp' ldimm.tsv
	touch $@

# Word synthetic sra hl is 16 T, not 8. Two nop + ret (18) wins.
srahl.ok: ../../../src/zcc-multi/t/srahl.asm ../../../src/zcc-multi/t/nops.asm
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=srahl_stitch.asm --report=srahl.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/srahl.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/nops.asm
	test `awk '/^_foo/ {print $$3}' srahl.tsv` = metric
	test `awk '/^_foo/ {print $$6}' srahl.tsv` -eq 26
	test `awk '/^_foo/ {print $$7}' srahl.tsv` -eq 18
	grep -q '^_foo.80cc-sp' srahl.tsv
	touch $@

# Pair copy and word rotate: native T-states when the CPU has the op,
# else two 8-bit / CB ops. Rabbit rr hl is 2 T. ld de,hl is 4 T. bool hl is 2 T.
r2ka.ok: ../../../src/zcc-multi/t/r2ka_rrhl.asm ../../../src/zcc-multi/t/r2ka_ldrr.asm \
	../../../src/zcc-multi/t/r2ka_bool.asm ../../../src/zcc-multi/t/nops.asm
	z88dk-zcc-multi --cpu=r2ka --metric=ticks --data-variant=sccz80 \
	  --output=r2ka_rrhl_stitch.asm --report=r2ka_rrhl.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/nops.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/r2ka_rrhl.asm
	test `awk '/^_foo/ {print $$3}' r2ka_rrhl.tsv` = metric
	test `awk '/^_foo/ {print $$7}' r2ka_rrhl.tsv` -eq 12
	grep -q '^_foo.80cc-sp' r2ka_rrhl.tsv
	z88dk-zcc-multi --cpu=r2ka --metric=ticks --data-variant=sccz80 \
	  --output=r2ka_ldrr_stitch.asm --report=r2ka_ldrr.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/nops.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/r2ka_ldrr.asm
	test `awk '/^_foo/ {print $$7}' r2ka_ldrr.tsv` -eq 14
	grep -q '^_foo.80cc-sp' r2ka_ldrr.tsv
	z88dk-zcc-multi --cpu=r2ka --metric=ticks --data-variant=sccz80 \
	  --output=r2ka_bool_stitch.asm --report=r2ka_bool.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/nops.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/r2ka_bool.asm
	test `awk '/^_foo/ {print $$7}' r2ka_bool.tsv` -eq 12
	grep -q '^_foo.80cc-sp' r2ka_bool.tsv
	z88dk-zcc-multi --cpu=r2ka --metric=ticks --data-variant=sccz80 \
	  --output=r2ka_addsp_stitch.asm --report=r2ka_addsp.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/nops.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/r2ka_addsp.asm
	test `awk '/^_foo/ {print $$3}' r2ka_addsp.tsv` = metric
	test `awk '/^_foo/ {print $$7}' r2ka_addsp.tsv` -eq 14
	grep -q '^_foo.80cc-sp' r2ka_addsp.tsv
	z88dk-zcc-multi --cpu=r2ka --metric=ticks --data-variant=sccz80 \
	  --output=r2ka_ldix_stitch.asm --report=r2ka_ldix.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/mix_fast.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/r2ka_ldix.asm
	test `awk '/^_foo/ {print $$3}' r2ka_ldix.tsv` = metric
	test `awk '/^_foo/ {print $$7}' r2ka_ldix.tsv` -eq 21
	grep -q '^_foo.80cc-sp' r2ka_ldix.tsv
	touch $@

# 80cc-fp ld hl,(ix+d) is two indexed loads (38 T), not unknown.
ixword.ok: ../../../src/zcc-multi/t/ixword.asm
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=ixword_stitch.asm --report=ixword.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/ixword.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/ixword.asm
	test `awk '/^_foo/ {print $$3}' ixword.tsv` = metric
	test `awk '/^_foo/ {print $$6}' ixword.tsv` -eq 48
	touch $@

# IY matches IX. Pair copies must score, not fallback.
# Z80 ld iy,hl = 25 T. ld iy,bc = 16 T. ld hl,(iy+d) = 38 T.
# Rabbit ld iy,hl is native 4 T. Z180 ld iy,bc is push/pop 25 T.
iy.ok: ../../../src/zcc-multi/t/iyld.asm ../../../src/zcc-multi/t/iyword.asm \
	../../../src/zcc-multi/t/iybc.asm ../../../src/zcc-multi/t/nops.asm
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=iyld_stitch.asm --report=iyld.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/iyld.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/iyld.asm
	test `awk '/^_foo/ {print $$3}' iyld.tsv` = metric
	test `awk '/^_foo/ {print $$6}' iyld.tsv` -eq 35
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=iyword_stitch.asm --report=iyword.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/iyword.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/iyword.asm
	test `awk '/^_foo/ {print $$3}' iyword.tsv` = metric
	test `awk '/^_foo/ {print $$6}' iyword.tsv` -eq 48
	z88dk-zcc-multi --cpu=z80 --metric=ticks --data-variant=sccz80 \
	  --output=iybc_stitch.asm --report=iybc.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/iybc.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/iybc.asm
	test `awk '/^_foo/ {print $$3}' iybc.tsv` = metric
	test `awk '/^_foo/ {print $$6}' iybc.tsv` -eq 26
	z88dk-zcc-multi --cpu=z80n --metric=ticks --data-variant=sccz80 \
	  --output=iybc_z80n_stitch.asm --report=iybc_z80n.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/iybc.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/iybc.asm
	test `awk '/^_foo/ {print $$6}' iybc_z80n.tsv` -eq 26
	z88dk-zcc-multi --cpu=z180 --metric=ticks --data-variant=sccz80 \
	  --output=iybc_z180_stitch.asm --report=iybc_z180.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/iybc.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/iybc.asm
	test `awk '/^_foo/ {print $$3}' iybc_z180.tsv` = metric
	test `awk '/^_foo/ {print $$6}' iybc_z180.tsv` -eq 35
	z88dk-zcc-multi --cpu=r2ka --metric=ticks --data-variant=sccz80 \
	  --output=iyld_r2ka_stitch.asm --report=iyld_r2ka.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/nops.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/iyld.asm
	test `awk '/^_foo/ {print $$3}' iyld_r2ka.tsv` = metric
	test `awk '/^_foo/ {print $$7}' iyld_r2ka.tsv` -eq 14
	touch $@

# 8085 extended ops (Zilog) have documented T-states. Unknown would
# fallback to size; a larger-but-faster body must still win on ticks.
ext8085.ok: ../../../src/zcc-multi/t/8085_ext.asm \
	../../../src/zcc-multi/t/8085_slow.asm ../../../src/zcc-multi/t/8085_fast.asm
	z88dk-zcc-multi --cpu=8085 --metric=ticks --data-variant=sccz80 \
	  --output=ext8085_stitch.asm --report=ext8085.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/8085_ext.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/8085_ext.asm
	test `awk '/^_foo/ {print $$3}' ext8085.tsv` = metric
	test `awk '/^_foo/ {print $$6}' ext8085.tsv` -eq 97
	z88dk-zcc-multi --cpu=8085 --metric=ticks --data-variant=sccz80 \
	  --output=ext8085_pick.asm --report=ext8085_pick.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/8085_slow.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/8085_fast.asm
	test `awk '/^_foo/ {print $$3}' ext8085_pick.tsv` = metric
	grep -q '^_foo.80cc-sp' ext8085_pick.tsv
	touch $@

# VM1 extended ops (Zilog) have documented T-states. Base times are 8080.
# Unknown would fallback to size; a larger-but-faster body must still win.
extvm1.ok: ../../../src/zcc-multi/t/vm1_ext.asm \
	../../../src/zcc-multi/t/vm1_slow.asm ../../../src/zcc-multi/t/vm1_fast.asm
	z88dk-zcc-multi --cpu=vm1 --metric=ticks --data-variant=sccz80 \
	  --output=extvm1_stitch.asm --report=extvm1.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/vm1_ext.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/vm1_ext.asm
	test `awk '/^_foo/ {print $$3}' extvm1.tsv` = metric
	test `awk '/^_foo/ {print $$6}' extvm1.tsv` -eq 135
	z88dk-zcc-multi --cpu=vm1 --metric=ticks --data-variant=sccz80 \
	  --output=extvm1_pick.asm --report=extvm1_pick.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/vm1_slow.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/vm1_fast.asm
	test `awk '/^_foo/ {print $$3}' extvm1_pick.tsv` = metric
	grep -q '^_foo.80cc-sp' extvm1_pick.tsv
	touch $@

# gbz80 extras (Zilog) have documented cycle counts. Unknown would
# fallback to size; a larger-but-faster body must still win on ticks.
extgbz80.ok: ../../../src/zcc-multi/t/gbz80_ext.asm \
	../../../src/zcc-multi/t/gbz80_slow.asm ../../../src/zcc-multi/t/gbz80_fast.asm
	z88dk-zcc-multi --cpu=gbz80 --metric=ticks --data-variant=sccz80 \
	  --output=extgbz80_stitch.asm --report=extgbz80.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/gbz80_ext.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/gbz80_ext.asm
	test `awk '/^_foo/ {print $$3}' extgbz80.tsv` = metric
	test `awk '/^_foo/ {print $$6}' extgbz80.tsv` -eq 144
	z88dk-zcc-multi --cpu=gbz80 --metric=ticks --data-variant=sccz80 \
	  --output=extgbz80_pick.asm --report=extgbz80_pick.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/gbz80_slow.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/gbz80_fast.asm
	test `awk '/^_foo/ {print $$3}' extgbz80_pick.tsv` = metric
	grep -q '^_foo.80cc-sp' extgbz80_pick.tsv
	touch $@

# gbz80 ex de,hl is 56 T (four stack ops). Larger-but-faster body wins on ticks.
gbz80ex.ok: ../../../src/zcc-multi/t/gbz80_ex.asm \
	../../../src/zcc-multi/t/gbz80_ex_slow.asm
	z88dk-zcc-multi --cpu=gbz80 --metric=ticks --data-variant=sccz80 \
	  --output=gbz80ex_stitch.asm --report=gbz80ex.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/gbz80_ex_slow.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/gbz80_ex.asm
	test `awk '/^_foo/ {print $$3}' gbz80ex.tsv` = metric
	test `awk -F'	' '/^_foo/ {print $$6}' gbz80ex.tsv` -eq 176
	test `awk -F'	' '/^_foo/ {print $$7}' gbz80ex.tsv` -eq 152
	grep -q '^_foo.80cc-sp' gbz80ex.tsv
	touch $@

# Z180 extras (Zilog). mlt / in0 / out0 / tst / tstio / otim.
extz180.ok: ../../../src/zcc-multi/t/z180_ext.asm \
	../../../src/zcc-multi/t/z180_slow.asm ../../../src/zcc-multi/t/z180_fast.asm
	z88dk-zcc-multi --cpu=z180 --metric=ticks --data-variant=sccz80 \
	  --output=extz180_stitch.asm --report=extz180.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/z180_ext.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/z180_ext.asm
	test `awk '/^_foo/ {print $$3}' extz180.tsv` = metric
	test `awk '/^_foo/ {print $$6}' extz180.tsv` -eq 94
	z88dk-zcc-multi --cpu=z180 --metric=ticks --data-variant=sccz80 \
	  --output=extz180_pick.asm --report=extz180_pick.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/z180_slow.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/z180_fast.asm
	test `awk '/^_foo/ {print $$3}' extz180_pick.tsv` = metric
	grep -q '^_foo.80cc-sp' extz180_pick.tsv
	touch $@

# Z80N extras (Zilog). mul / nextreg / add rr,a / push imm / swapnib.
extz80n.ok: ../../../src/zcc-multi/t/z80n_ext.asm \
	../../../src/zcc-multi/t/z80n_slow.asm ../../../src/zcc-multi/t/z80n_fast.asm
	z88dk-zcc-multi --cpu=z80n --metric=ticks --data-variant=sccz80 \
	  --output=extz80n_stitch.asm --report=extz80n.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/z80n_ext.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/z80n_ext.asm
	test `awk '/^_foo/ {print $$3}' extz80n.tsv` = metric
	test `awk '/^_foo/ {print $$6}' extz80n.tsv` -eq 175
	z88dk-zcc-multi --cpu=z80n --metric=ticks --data-variant=sccz80 \
	  --output=extz80n_pick.asm --report=extz80n_pick.tsv \
	  --variant=sccz80:../../../src/zcc-multi/t/z80n_slow.asm \
	  --variant=80cc-sp:../../../src/zcc-multi/t/z80n_fast.asm
	test `awk '/^_foo/ {print $$3}' extz80n_pick.tsv` = metric
	grep -q '^_foo.80cc-sp' extz80n_pick.tsv
	touch $@

# Command-line multi vs a recipe that sets -compiler=sdcc is the sdcc ABI.
sdcc_abi.ok: twofuncs.c
	if zcc +cpm -clib=sdcc_iy -vn -c -compiler=multi twofuncs.c -o sdcc_abi.o 2>sdcc_abi.err; then exit 1; fi
	grep -q -- '-compiler=multi does not support the sdcc ABI' sdcc_abi.err
	if grep -q zsdcc sdcc_abi.err; then exit 1; fi
	if zcc +cpm -clib=sdcc_ix -vn -c -compiler=multi twofuncs.c -o sdcc_abi.o 2>sdcc_abi.err; then exit 1; fi
	grep -q -- '-compiler=multi does not support the sdcc ABI' sdcc_abi.err
	if zcc +rc2014 -vn -c -compiler=multi twofuncs.c -o sdcc_abi.o 2>sdcc_abi.err; then exit 1; fi
	grep -q -- '-compiler=multi does not support the sdcc ABI' sdcc_abi.err
	touch $@

clean:
	$(RM) *.ok *.asm *.o *.bin *.map *.tsv *.lis *.sym *.err twofuncs twofuncs.bin fb_stitch.asm loop_stitch.asm loop_b0_stitch.asm loop_bc0_stitch.asm loop_bc_nz_stitch.asm loop_8085_k_stitch.asm loop_8085_k0_stitch.asm loop_vm1_of_stitch.asm ldir_bc0_stitch.asm ldimm_stitch.asm mixfb_stitch.asm only_stitch.asm srahl_stitch.asm r2ka_rrhl_stitch.asm r2ka_ldrr_stitch.asm r2ka_bool_stitch.asm r2ka_addsp_stitch.asm r2ka_ldix_stitch.asm ixword_stitch.asm ext8085_stitch.asm ext8085_pick.asm extvm1_stitch.asm extvm1_pick.asm extgbz80_stitch.asm extgbz80_pick.asm extz180_stitch.asm extz180_pick.asm extz80n_stitch.asm extz80n_pick.asm opt_used.asm opt_used.bin sdcc_abi.o

.PHONY: all clean
