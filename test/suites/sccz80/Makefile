include ../make.config



CFLAGS +=  -DNO_LOG_RUNNING -DNO_LOG_PASSED

# --opt-code-speed is an sccz80-only knob; 80cc (and other compilers) reject it.
OPT_CODE_SPEED := $(if $(filter sccz80,$(COMPILER)),-Cc--opt-code-speed=all)

TARGET_Z80N = test_z80n_rshift.bin test_z80n_lshift.bin test_z80n_selfstruct.bin
TARGET_8080 = test_8080_bitfields.bin test_8080_rshift.bin test_8080_lshift.bin test_8080_compare.bin test_8080_compare0.bin test_8080_compare_const.bin test_8080_compare_mconst.bin test_8080_compare_castconst.bin test_8080_signcmp.bin test_8080_ptrinc.bin test_8080_mult.bin test_8080_division.bin test_8080_bitwise.bin test_8080_selfstruct.bin
TARGET_8085 = test_8085_bitfields.bin test_8085_rshift.bin test_8085_lshift.bin test_8085_compare.bin test_8085_compare0.bin test_8085_compare_const.bin test_8085_compare_mconst.bin test_8085_compare_castconst.bin test_8085_signcmp.bin test_8085_ptrinc.bin test_8085_mult.bin test_8085_division.bin test_8085_bitwise.bin test_8085_selfstruct.bin
TARGET_VM1 = test_vm1_bitfields.bin test_vm1_rshift.bin test_vm1_lshift.bin test_vm1_compare.bin test_vm1_compare0.bin test_vm1_compare_const.bin test_vm1_compare_mconst.bin test_vm1_compare_castconst.bin test_vm1_signcmp.bin test_vm1_ptrinc.bin test_vm1_mult.bin test_vm1_division.bin test_vm1_bitwise.bin test_vm1_selfstruct.bin
TARGET_GBZ80 = test_gbz80_rshift.bin test_gbz80_lshift.bin test_gbz80_compare.bin test_gbz80_compare0.bin test_gbz80_compare_const.bin test_gbz80_compare_mconst.bin test_gbz80_compare_castconst.bin test_gbz80_signcmp.bin test_gbz80_ptrinc.bin test_gbz80_mult.bin test_gbz80_division.bin test_gbz80_bitfields.bin test_gbz80_bitwise.bin test_gbz80_uminus.bin test_gbz80_loops.bin test_gbz80_selfstruct.bin
TARGET_R2KA = test_r2ka_bitfields.bin test_r2ka_rshift.bin test_r2ka_lshift.bin test_r2ka_compare.bin test_r2ka_compare0.bin test_r2ka_compare_const.bin test_r2ka_compare_mconst.bin test_r2ka_compare_castconst.bin test_r2ka_mult.bin test_r2ka_division.bin test_r2ka_bitwise.bin test_r2ka_selfstruct.bin
TARGET_R4K = test_r4k_bitfields.bin test_r4k_rshift.bin test_r4k_lshift.bin test_r4k_compare.bin test_r4k_compare0.bin test_r4k_compare_const.bin test_r4k_compare_mconst.bin test_r4k_compare_castconst.bin test_r4k_mult.bin test_r4k_division.bin test_r4k_bitwise.bin test_r4k_selfstruct.bin
TARGET_R6K = test_r6k_bitfields.bin test_r6k_rshift.bin test_r6k_lshift.bin test_r6k_compare.bin test_r6k_compare0.bin test_r6k_compare_const.bin test_r6k_compare_mconst.bin test_r6k_compare_castconst.bin test_r6k_mult.bin test_r6k_division.bin test_r6k_bitwise.bin test_r6k_selfstruct.bin
TARGET_RC2014 = test_rc2014_rshift_CODE.bin test_rc2014_lshift_CODE.bin test_rc2014_compare_CODE.bin test_rc2014_compare0_CODE.bin test_rc2014_compare_const_CODE.bin test_rc2014_compare_mconst_CODE.bin test_rc2014_compare_castconst_CODE.bin test_rc2014_mult_CODE.bin test_rc2014_division_CODE.bin test_rc2014_bitfields_CODE.bin test_rc2014_bitwise_CODE.bin test_rc2014_uminus_CODE.bin test_rc2014_loops_CODE.bin test_rc2014_selfstruct_CODE.bin
TARGET_KC160 = test_kc160_bitfields.bin test_kc160_rshift.bin test_kc160_lshift.bin test_kc160_compare.bin test_kc160_compare0.bin test_kc160_compare_const.bin test_kc160_compare_mconst.bin test_kc160_compare_castconst.bin test_kc160_mult.bin test_kc160_division.bin test_kc160_bitwise.bin test_kc160_selfstruct.bin


CFILES = $(wildcard *.c)
# constpush.c is the #321 fold suite. sccz80 and 80cc run it.
# conv.c is the same compilers: char promotion, far compare, pointer
# difference, and the long-constant add. sdcc rejects __far here, and
# multi is not this suite. switchinit.c runs under every compiler.
ifeq ($(filter $(COMPILER),sccz80 80cc),)
CFILES := $(filter-out constpush.c conv.c,$(CFILES))
endif
# calllimit.c is expected to fail. It is checked separately, not run.
# declbad.c is expected to fail. It is checked separately, not run.
# declskip_*.c each fail with one diagnostic. They are not run.
# callargs.c fills sccz80's argument table. 80cc does not compile it.
# declspec.c is issue #2335. 80cc still rejects qualifier-before-storage.
# selfstruct.c stays in CFILES, so the default z80 target runs it too.
# critical_isr.c is an asm lock. It has no main.
# critical_leave_asm.c and critical_leave_isr.c are asm locks.
# critical_into.c is expected to fail.
# critical.c is the sccz80 stack-offset lock.
# critical_leave.c is the leave value suite. sccz80 and 80cc both run it.
CFILES := $(filter-out calllimit.c declbad.c declskip_str.c declskip_brace.c critical_isr.c critical_leave_asm.c critical_leave_isr.c critical_into.c,$(CFILES))
ifneq ($(COMPILER),sccz80)
CFILES := $(filter-out callargs.c declspec.c critical.c,$(CFILES))
endif
ifeq ($(filter $(COMPILER),sccz80 80cc),)
CFILES := $(filter-out critical_leave.c,$(CFILES))
endif
TARGET_Z80 := $(foreach test,$(CFILES:.c=),test_$(test).bin)

ifeq ($(COMPILER),xcc)
all: $(TARGET_Z80)
else
all: $(TARGET_Z80) $(TARGET_8080) $(TARGET_8085) $(TARGET_VM1) $(TARGET_GBZ80) $(TARGET_Z80N) $(TARGET_R2KA) $(TARGET_RC2014) $(TARGET_R4K) $(TARGET_R6K) $(TARGET_KC160)
endif

# One past the fixed argument table must be diagnosed, not stored.
# declbad.c must diagnose specifier errors and must not leak a block typedef.
ifeq ($(COMPILER),sccz80)
all: test_calllimit test_declbad test_declskip test_declspec_sfr test_critical_isr test_critical_asm test_critical_leave test_critical_leave_isr test_critical_into
endif
ifeq ($(filter $(COMPILER),sccz80 80cc),$(COMPILER))
all: test_8080_critical_leave.bin test_8085_critical_leave.bin test_vm1_critical_leave.bin test_gbz80_critical_leave.bin test_r2ka_critical_leave.bin test_z80n_critical_leave.bin test_z180_critical_leave.bin test_ez80_z80_critical_leave.bin test_kc160_critical_leave.bin test_r800_critical_leave.bin test_r4k_critical_leave.bin test_r6k_critical_leave.bin
endif

.PHONY: test_calllimit
test_calllimit: calllimit.c
	-zcc +test -vn -c -compiler=sccz80 $< -o calllimit.o > calllimit.output 2>&1
	grep -F "Too many arguments in a call, the limit is 98" calllimit.output
	rm -f calllimit.o calllimit.output

.PHONY: test_declbad
test_declbad: declbad.c
	-zcc +test -vn -c -compiler=sccz80 $< -o declbad.o > declbad.output 2>&1
	grep -F "Function modifier __preserves_regs must follow the declarator" declbad.output
	grep -F "More than one storage class in declaration" declbad.output
	grep -F "Storage class specifier is not permitted here" declbad.output
	grep -F "Missing token, expecting ( got l" declbad.output
	grep -F "Typedef 'Tval' is not a variable" declbad.output
	grep -F "Found K&R declaration" declbad.output && exit 1 || true
	rm -f declbad.o declbad.output

# Each file is already invalid. Recovery must add no second diagnostic.
.PHONY: test_declskip
test_declskip: declskip_str.c declskip_brace.c
	-zcc +test -vn -c -compiler=sccz80 declskip_str.c -o declskip_str.o > declskip_str.output 2>&1
	grep -F "Typedef 'Tstr' is not a variable" declskip_str.output
	test `grep -c -E ": (fatal )?error:" declskip_str.output` -eq 1
	-zcc +test -vn -c -compiler=sccz80 declskip_brace.c -o declskip_brace.o > declskip_brace.output 2>&1
	grep -F "Typedef 'Tbr' is not a variable" declskip_brace.output
	test `grep -c -E ": (fatal )?error:" declskip_brace.output` -eq 1
	rm -f declskip_str.o declskip_brace.o declskip_str.output declskip_brace.output

# Ticks does not loop an I/O port back to in. Lock the spelling in the asm.
.PHONY: test_declspec_sfr
test_declspec_sfr: declspec.c
	zcc +test -vn -a -I../../framework -compiler=sccz80 declspec.c -o declspec_sfr.opt
	grep -F "defc	_io_port" declspec_sfr.opt
	grep -F "in	a,(_io_port)" declspec_sfr.opt
	grep -F "out	(_io_port),a" declspec_sfr.opt
	grep -F "defc	_sfr_ul" declspec_sfr.opt
	grep -F "defc	_sfr_cc" declspec_sfr.opt
	grep -F "defc	_sfr_l" declspec_sfr.opt
	grep -F "call	l_push_di" declspec_sfr.opt
	grep -F "call	l_pop_ei" declspec_sfr.opt
	rm -f declspec_sfr.opt

# 8080 and VM1: a bare __interrupt keeps one di.
# __interrupt(0) and a critical interrupt add no di.
# Four ei: bare entry, bare block, numbered epilogue, critical numbered epilogue.
# Each handler returns with ret.
# 8085 keeps the block with l_push_di and l_pop_ei.
# Three ei: bare entry, numbered epilogue, critical numbered epilogue.
# gbz80 uses reti for a maskable handler and ret for __critical __interrupt.
# Z80 uses reti for a maskable handler and retn for __critical __interrupt.
# Rabbit interrupt blocks keep ipset 3 and ipres. A critical interrupt does too.
# Two plain handlers are two ipset and four ipres. The two critical handlers
# add two ipset and three ipres.
.PHONY: test_critical_isr
test_critical_isr: critical_isr.c
	zcc +test -vn -clib=8080 -compiler=sccz80 -S $< -o critical_isr.asm
	test `grep -c '^	di$$' critical_isr.asm` -eq 1
	test `grep -c '^	ei$$' critical_isr.asm` -eq 4
	test `grep -c '^	ret$$' critical_isr.asm` -eq 4
	grep -E '^	reti$$' critical_isr.asm && exit 1 || true
	grep -E '^	retn$$' critical_isr.asm && exit 1 || true
	rm -f critical_isr.asm
	zcc +test -vn -clib=8085 -compiler=sccz80 -S $< -o critical_isr.asm
	test `grep -c '^	di$$' critical_isr.asm` -eq 0
	test `grep -c '^	ei$$' critical_isr.asm` -eq 3
	test `grep -c '^	ret$$' critical_isr.asm` -eq 4
	grep -E '^	reti$$' critical_isr.asm && exit 1 || true
	grep -E '^	retn$$' critical_isr.asm && exit 1 || true
	rm -f critical_isr.asm
	zcc +test -vn -clib=vm1 -compiler=sccz80 -S $< -o critical_isr.asm
	test `grep -c '^	di$$' critical_isr.asm` -eq 1
	test `grep -c '^	ei$$' critical_isr.asm` -eq 4
	test `grep -c '^	ret$$' critical_isr.asm` -eq 4
	grep -E '^	reti$$' critical_isr.asm && exit 1 || true
	grep -E '^	retn$$' critical_isr.asm && exit 1 || true
	rm -f critical_isr.asm
	zcc +test -vn -clib=gbz80 -compiler=sccz80 -S $< -o critical_isr.asm
	test `grep -c '^	di$$' critical_isr.asm` -eq 1
	test `grep -c '^	ei$$' critical_isr.asm` -eq 4
	test `grep -c '^	ret$$' critical_isr.asm` -eq 1
	test `grep -c '^	reti$$' critical_isr.asm` -eq 3
	grep -E '^	retn$$' critical_isr.asm && exit 1 || true
	rm -f critical_isr.asm
	zcc +test -vn -compiler=sccz80 -S $< -o critical_isr.asm
	test `grep -c '^	ei$$' critical_isr.asm` -eq 3
	test `grep -c '^	reti$$' critical_isr.asm` -eq 3
	test `grep -c '^	retn$$' critical_isr.asm` -eq 1
	grep -E '^	ret$$' critical_isr.asm && exit 1 || true
	rm -f critical_isr.asm
	zcc +test -vn -clib=rabbit -compiler=sccz80 -S $< -o critical_isr.asm
	test `grep -c '^	ipset	3$$' critical_isr.asm` -eq 4
	test `grep -c '^	ipres$$' critical_isr.asm` -eq 7
	grep -F "reti" critical_isr.asm
	rm -f critical_isr.asm

# This lock guards the stack offsets from the return fix.
# It is not the interrupt lock. Master records the argument at sp+4
# and emits l_gint8sp. This compiler keeps the argument at sp+2.
# The nested pair loads l_gint6sp.
.PHONY: test_critical_asm
test_critical_asm: critical.c
	zcc +test -vn -I../../framework -compiler=sccz80 -S $< -o critical.asm
	grep -F "parameter 'int x' at sp+2 size(2)" critical.asm
	grep -F "call	l_gint6sp" critical.asm
	grep -F "at sp+4 size(2)" critical.asm && exit 1 || true
	grep -F "l_gint8sp" critical.asm && exit 1 || true
	grep -F "	push	bc" critical.asm && exit 1 || true
	rm -f critical.asm

# break_out and goto_out each leave the statement: one leave on that
# path and the block leave. break_in and goto_in stay inside: the block
# leave only. suppressed is a critical function. Its inner statement
# pushes a word on a save cpu and emits nothing on a flagless cpu.
# Save cpus: four statement enters, plus the function and its statement.
# Flagless cpus: four statement enters, plus the function enter only.
.PHONY: test_critical_leave
test_critical_leave: critical_leave_asm.c
	zcc +test -vn -compiler=sccz80 -S $< -o $@.lst
	test `grep -c 'l_push_di' $@.lst` -eq 6
	test `grep -c 'l_pop_ei' $@.lst` -eq 9
	test `grep -c '^	di$$' $@.lst` -eq 0
	test `grep -c '^	ei$$' $@.lst` -eq 0
	rm -f $@.lst
	zcc +test -vn -clib=8085 -compiler=sccz80 -S $< -o $@.lst
	test `grep -c 'l_push_di' $@.lst` -eq 6
	test `grep -c 'l_pop_ei' $@.lst` -eq 9
	test `grep -c '^	di$$' $@.lst` -eq 0
	rm -f $@.lst
	zcc +test -vn -clib=8080 -compiler=sccz80 -S $< -o $@.lst
	test `grep -c '^	di$$' $@.lst` -eq 5
	test `grep -c '^	ei$$' $@.lst` -eq 7
	rm -f $@.lst
	zcc +test -vn -clib=vm1 -compiler=sccz80 -S $< -o $@.lst
	test `grep -c '^	di$$' $@.lst` -eq 5
	test `grep -c '^	ei$$' $@.lst` -eq 7
	rm -f $@.lst
	zcc +test -vn -clib=gbz80 -compiler=sccz80 -S $< -o $@.lst
	test `grep -c '^	di$$' $@.lst` -eq 5
	test `grep -c '^	ei$$' $@.lst` -eq 7
	rm -f $@.lst
	zcc +test -vn -clib=rabbit -compiler=sccz80 -S $< -o $@.lst
	test `grep -c '^	ipset	3$$' $@.lst` -eq 5
	test `grep -c '^	ipres$$' $@.lst` -eq 7
	rm -f $@.lst

# A return inside the statement leaves it, then the handler epilogue
# runs. The block leave and the closing epilogue follow that return.
# The bare break and the bare goto add a leave on that edge. Those two
# moves are what the Z80 and 8085 rows add over a return-only handler.
# 8080 bare is the di. Numbered and critical handlers add no di.
# 8085 keeps the statement with l_push_di. gbz80 uses reti except for
# __critical __interrupt. Z80 uses reti and retn the same way.
.PHONY: test_critical_leave_isr
test_critical_leave_isr: critical_leave_isr.c
	zcc +test -vn -clib=8080 -compiler=sccz80 -S $< -o $@.lst
	test `grep -c '^	di$$' $@.lst` -eq 3
	test `grep -c '^	ei$$' $@.lst` -eq 13
	test `grep -c '^	ret$$' $@.lst` -eq 10
	grep -E '^	reti$$' $@.lst && exit 1 || true
	grep -E '^	retn$$' $@.lst && exit 1 || true
	rm -f $@.lst
	zcc +test -vn -clib=8085 -compiler=sccz80 -S $< -o $@.lst
	test `grep -c '^	di$$' $@.lst` -eq 0
	test `grep -c '^	ei$$' $@.lst` -eq 7
	test `grep -c 'l_push_di' $@.lst` -eq 6
	test `grep -c 'l_pop_ei' $@.lst` -eq 12
	test `grep -c '^	ret$$' $@.lst` -eq 10
	grep -E '^	reti$$' $@.lst && exit 1 || true
	rm -f $@.lst
	zcc +test -vn -clib=vm1 -compiler=sccz80 -S $< -o $@.lst
	test `grep -c '^	di$$' $@.lst` -eq 3
	test `grep -c '^	ei$$' $@.lst` -eq 13
	test `grep -c '^	ret$$' $@.lst` -eq 10
	grep -E '^	reti$$' $@.lst && exit 1 || true
	rm -f $@.lst
	zcc +test -vn -clib=gbz80 -compiler=sccz80 -S $< -o $@.lst
	test `grep -c '^	di$$' $@.lst` -eq 3
	test `grep -c '^	ei$$' $@.lst` -eq 13
	test `grep -c '^	ret$$' $@.lst` -eq 2
	test `grep -c '^	reti$$' $@.lst` -eq 8
	grep -E '^	retn$$' $@.lst && exit 1 || true
	rm -f $@.lst
	zcc +test -vn -compiler=sccz80 -S $< -o $@.lst
	test `grep -c '^	ei$$' $@.lst` -eq 7
	test `grep -c 'l_push_di' $@.lst` -eq 6
	test `grep -c 'l_pop_ei' $@.lst` -eq 12
	test `grep -c '^	reti$$' $@.lst` -eq 8
	test `grep -c '^	retn$$' $@.lst` -eq 2
	grep -E '^	ret$$' $@.lst && exit 1 || true
	rm -f $@.lst
	zcc +test -vn -clib=rabbit -compiler=sccz80 -S $< -o $@.lst
	test `grep -c '^	ipset	3$$' $@.lst` -eq 6
	test `grep -c '^	ipres$$' $@.lst` -eq 19
	test `grep -c '^	ret$$' $@.lst` -eq 2
	test `grep -c '^	reti$$' $@.lst` -eq 8
	rm -f $@.lst

# A goto into a statement __critical is rejected. A case or default
# inside the block is a separate message. Nested statement __critical
# stays a fatal error. The same three messages are reported on each cpu.
INTO_CLIBS = z80 8080 8085 vm1 gbz80 rabbit rabbit4k rabbit6k z80n z180 ez80_z80 kc160 r800
.PHONY: test_critical_into
test_critical_into: critical_into.c
	@set -e; for clib in $(INTO_CLIBS); do \
	  if [ "$$clib" = z80 ]; then flags=""; else flags="-clib=$$clib"; fi; \
	  echo "critical_into $$clib"; \
	  zcc +test -vn -c -compiler=sccz80 $$flags $< -o critical_into.o > critical_into.output 2>&1 || true; \
	  test `grep -c -F "goto into __critical" critical_into.output` -eq 2; \
	  test `grep -c -F "case into __critical" critical_into.output` -eq 2; \
	  grep -q -F "Cannot nest __critical sections" critical_into.output; \
	done
	rm -f critical_into.o critical_into.output

# double_t is 6 bytes here (four values, 24 bytes). --genmath keeps that width.
test_autoinit.bin: $(SOURCES) autoinit.c
	$(call compile, -DGENMATH -DMATH_LIBRARY="\"\\\"Genmath\\\"\"", --genmath )
	$(runtest)

test_callee.bin: $(SOURCES) callee.c
	$(call compile,-lm)
	$(runtest)

test_fastcall_callee.bin: $(SOURCES) fastcall_callee.c
	$(call compile,-lm)
	$(runtest)

# (long)1E5 is folded by sccz80 and calls ifix on 80cc.
test_constlit.bin: $(SOURCES) constlit.c
	$(call compile,-lm)
	$(runtest)

test_compare.bin: $(SOURCES) compare.c
	$(call compile, $(OPT_CODE_SPEED),)
	$(runtest)

test_literal.bin: $(SOURCES) literal.c
	$(call compile,,-lmath48)
	$(runtest)


test_%.bin: $(SOURCES) %.c
	$(compile)
	$(runtest)

test_8080_%.bin: $(SOURCES) %.c
	$(compile_8080)
	$(runtest_8080)

test_8085_%.bin: $(SOURCES) %.c
	$(compile_8085)
	$(runtest_8085)

test_vm1_%.bin: $(SOURCES) %.c
	$(compile_vm1)
	$(runtest_vm1)

test_gbz80_%.bin: $(SOURCES) %.c
	$(compile_gbz80)
	$(runtest_gbz80)

test_z80n_%.bin: $(SOURCES) %.c
	$(compile_z80n)
	$(runtest_z80n)

test_z180_%.bin: $(SOURCES) %.c
	$(compile_z180)
	$(runtest_z180)

test_ez80_z80_%.bin: $(SOURCES) %.c
	$(compile_ez80_z80)
	$(runtest_ez80_z80)

test_r800_%.bin: $(SOURCES) %.c
	$(compile_r800)
	$(runtest_r800)
	
test_r2ka_%.bin: $(SOURCES) %.c
	$(compile_r2ka)
	$(runtest_r2ka)

test_r4k_%.bin: $(SOURCES) %.c
	$(compile_r4k)
	$(runtest_r4k)

test_r6k_%.bin: $(SOURCES) %.c
	$(compile_r6k)
	$(runtest_r6k)

test_kc160_%.bin: $(SOURCES) %.c
	$(compile_kc160)
	$(runtest_kc160)


test_rc2014_%_CODE.bin: $(SOURCES) %.c
	$(compile_rc2014)
	$(runtest_rc2014)

clean:
	rm -f *.bin *.map $(OBJECTS) zcc_opt.def *~ *.lis
