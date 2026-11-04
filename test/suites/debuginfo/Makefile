include ../make.config

# 80cc-only debug-info regression: compile with -debug and drive z88dk-ticks to
# confirm named locals/params resolve to their real values (see check.sh).
# Covers the IX frame (z80) and the software __debug_framepointer chain
# (8080/8085/gbz80). gbz80 needs the l_debug_* helpers in gbz80_crt0.lib.

DFLAGS = -vn -compiler=$(COMPILER) -debug -I$(FRAMEWORK_DIR)

# The harness is a POSIX shell driver (check.sh) that scripts z88dk-ticks over
# stdin; it doesn't run under Windows shells (cygwin/mingw/msys). Skip the whole
# suite there — compile included — rather than pay the build only to fail.
UNAME := $(shell uname -s 2>/dev/null)
DBG_WINDOWS :=
ifeq ($(OS),Windows_NT)
DBG_WINDOWS := 1
endif
ifneq (,$(findstring CYGWIN,$(UNAME)))
DBG_WINDOWS := 1
endif
ifneq (,$(findstring MINGW,$(UNAME)))
DBG_WINDOWS := 1
endif
ifneq (,$(findstring MSYS,$(UNAME)))
DBG_WINDOWS := 1
endif

ifdef DBG_WINDOWS
all:
	@echo "debuginfo: skipped (POSIX-shell debugger harness; not run on Windows)"
else
all: z80 i8080 i8085 gbz80 exprerr
endif

# the enum targets: their own lines, so exprerr can be reverted alone
all: enums dupname enumblk

z80: dbgvars.c
	zcc +test $(DFLAGS) $< -o dbgvars_z80.bin -m
	@sh ./check.sh -mz80 dbgvars_z80.bin dbgvars_z80.map z80

i8080: dbgvars.c
	zcc +test $(DFLAGS) -clib=8080 $< -o dbgvars_8080.bin -m
	@sh ./check.sh -m8080 dbgvars_8080.bin dbgvars_8080.map 8080

i8085: dbgvars.c
	zcc +test $(DFLAGS) -clib=8085 $< -o dbgvars_8085.bin -m
	@sh ./check.sh -m8085 dbgvars_8085.bin dbgvars_8085.map 8085

gbz80: dbgvars.c
	zcc +test $(DFLAGS) -clib=gbz80 $< -o dbgvars_gbz80.bin -m
	@sh ./check.sh -mgbz80 dbgvars_gbz80.bin dbgvars_gbz80.map gbz80

# An unknown name in an expression gives its error instead of crashing ticks
exprerr: z80
	@sh ./check_exprerr.sh -mz80 dbgvars_z80.bin dbgvars_z80.map z80

clean:
	$(RM) *.bin *.map *.o *.sym *.def zcc_opt.def *.lis

.PHONY: all z80 i8080 i8085 gbz80 exprerr clean
.PHONY: enums dupname enumblk clean-enums

# Enum objects print their enumerator (two modules, same-named enums, a shared header);
# both compilers, whichever COMPILER the suite runs with, as they write the same records
enums: enums_a.c enums_b.c enums_c.c enums.h enums_a.records
	@for c in sccz80 80cc; do \
	  zcc +test -vn -compiler=$$c -debug -I$(FRAMEWORK_DIR) enums_a.c enums_b.c enums_c.c -o enums_$$c.bin -m || exit 1; \
	  sh ./check_enums.sh -mz80 enums_$$c.bin enums_$$c.map $$c || exit 1; \
	  zcc +test -vn -compiler=$$c -debug -I$(FRAMEWORK_DIR) -a enums_a.c -o enums_a_$$c.asm || exit 1; \
	  sh ./check_enumrecs.sh enums_a_$$c.asm $$c || exit 1; \
	done

# Sibling-block locals of the same name and different enums (sccz80: 80cc writes no block-local records)
enumblk: enums_blk.c
	zcc +test -vn -compiler=sccz80 -debug -I$(FRAMEWORK_DIR) enums_blk.c -o enumblk_z80.bin -m
	@sh ./check_enumblk.sh -mz80 enumblk_z80.bin enumblk_z80.map z80

# Two modules of the same file name (other directories) have the same enum key; both compilers
dupname: dupname/dup1/dup.c dupname/dup2/dup.c
	@for c in sccz80 80cc; do \
	  (cd dupname/dup1 && zcc +test -vn -compiler=$$c -debug -c dup.c -o ../dup1_$$c.o) || exit 1; \
	  (cd dupname/dup2 && zcc +test -vn -compiler=$$c -debug -c dup.c -o ../dup2_$$c.o) || exit 1; \
	  zcc +test -vn -compiler=$$c -debug dupname/dup1_$$c.o dupname/dup2_$$c.o -o dupname_$$c.bin -m || exit 1; \
	  sh ./check_dupname.sh -mz80 dupname_$$c.bin dupname_$$c.map $$c || exit 1; \
	done

clean: clean-enums
clean-enums:
	$(RM) dupname/*.o dupname/*/*.o enums_a_*.asm
