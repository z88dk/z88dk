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
all: z80 i8080 i8085 gbz80 arrays exprerr
endif

# the enum targets: their own lines, so exprerr can be reverted alone
ifndef DBG_WINDOWS
all: enums dupname enumblk
endif

ifndef DBG_WINDOWS
all: floats
endif

z80: dbgvars.c dbglocals.c dbgparams.c
	zcc +test $(DFLAGS) $< -o dbgvars_z80.bin -m
	@sh ./check.sh -mz80 dbgvars_z80.bin dbgvars_z80.map z80
	zcc +test $(DFLAGS) dbglocals.c -o dbglocals_z80.bin -m
	@sh ./check_locals.sh -mz80 dbglocals_z80.bin dbglocals_z80.map z80
	zcc +test $(DFLAGS) dbgparams.c -o dbgparams_z80.bin -m
	@sh ./check_params.sh -mz80 dbgparams_z80.bin dbgparams_z80.map z80

i8080: dbgvars.c dbglocals.c dbgparams.c
	zcc +test $(DFLAGS) -clib=8080 $< -o dbgvars_8080.bin -m
	@sh ./check.sh -m8080 dbgvars_8080.bin dbgvars_8080.map 8080
	zcc +test $(DFLAGS) -clib=8080 dbglocals.c -o dbglocals_8080.bin -m
	@sh ./check_locals.sh -m8080 dbglocals_8080.bin dbglocals_8080.map 8080
	zcc +test $(DFLAGS) -clib=8080 dbgparams.c -o dbgparams_8080.bin -m
	@sh ./check_params.sh -m8080 dbgparams_8080.bin dbgparams_8080.map 8080

i8085: dbgvars.c dbglocals.c dbgparams.c
	zcc +test $(DFLAGS) -clib=8085 $< -o dbgvars_8085.bin -m
	@sh ./check.sh -m8085 dbgvars_8085.bin dbgvars_8085.map 8085
	zcc +test $(DFLAGS) -clib=8085 dbglocals.c -o dbglocals_8085.bin -m
	@sh ./check_locals.sh -m8085 dbglocals_8085.bin dbglocals_8085.map 8085
	zcc +test $(DFLAGS) -clib=8085 dbgparams.c -o dbgparams_8085.bin -m
	@sh ./check_params.sh -m8085 dbgparams_8085.bin dbgparams_8085.map 8085

gbz80: dbgvars.c dbglocals.c dbgparams.c
	zcc +test $(DFLAGS) -clib=gbz80 $< -o dbgvars_gbz80.bin -m
	@sh ./check.sh -mgbz80 dbgvars_gbz80.bin dbgvars_gbz80.map gbz80
	zcc +test $(DFLAGS) -clib=gbz80 dbglocals.c -o dbglocals_gbz80.bin -m
	@sh ./check_locals.sh -mgbz80 dbglocals_gbz80.bin dbglocals_gbz80.map gbz80
	zcc +test $(DFLAGS) -clib=gbz80 dbgparams.c -o dbgparams_gbz80.bin -m
	@sh ./check_params.sh -mgbz80 dbgparams_gbz80.bin dbgparams_gbz80.map gbz80

arrays: dbgarr.c
	zcc +test $(DFLAGS) $< -o dbgarr.bin -m
	@sh ./check-arrays.sh dbgarr.bin dbgarr.map

# An unknown name in an expression gives its error instead of crashing ticks
exprerr: z80
	@sh ./check_exprerr.sh -mz80 dbgvars_z80.bin dbgvars_z80.map z80

clean:
	$(RM) *.bin *.map *.o *.sym *.def zcc_opt.def *.lis

.PHONY: all z80 i8080 i8085 gbz80 arrays exprerr clean
.PHONY: enums dupname enumblk clean-enums
.PHONY: floats

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

# Floats print their value, each in the format its module gives in the map (z80 48-bit,
# with any exponent bias and mantissa size, IEEE, mbf32, mbf40, mbf64, z88 and the
# AM9511's), also in a link of modules built in two formats. Both compilers. floats_a/b/n.c
# have no float code, so any format links (mbf40 has no library, mbf64's needs a target's
# ROM); floats_r.c's floats are computed at run time by each library that ticks can run.
floats: floats_a.c floats_b.c floats_n.c floats.h floats_p.c floats_r.c floats_i.c floats_kinds.c
	@for c in sccz80 80cc; do \
	  for m in math48 math32 z80bias129 mbf32 mbf40 mbf64 bbc z88 dai32; do \
	    case $$m in \
	      z80bias129) lib="--math48 -Cc-fp-exponent-bias=129 -Cc-fp-mantissa-size=4" ;; \
	      mbf40) lib="-Cc-fp-mode=mbf40" ;; \
	      z88) lib="-Cc-math-z88 -lz88_math" ;; \
	      math48|math32) lib=--$$m ;; \
	      *) lib=--math-$$m ;; \
	    esac; \
	    zcc +test -vn -compiler=$$c -debug $$lib floats_a.c floats_b.c floats_n.c -o floats_$${c}_$$m.bin -m || exit 1; \
	    sh ./check_floats.sh -mz80 floats_$${c}_$$m.bin floats_$${c}_$$m.map $$c-$$m $$m || exit 1; \
	  done; \
	  for m in math48 math32 mbf32 bbc dai32; do \
	    case $$m in math48|math32) lib=--$$m ;; *) lib=--math-$$m ;; esac; \
	    zcc +test -vn -compiler=$$c -debug $$lib floats_r.c -o floats_$${c}_run_$$m.bin -m || exit 1; \
	    sh ./check_floats_run.sh -mz80 floats_$${c}_run_$$m.bin floats_$${c}_run_$$m.map $$c-run-$$m $$m || exit 1; \
	  done; \
	  zcc +test -vn -compiler=$$c -debug --math-bbc floats_i.c -o floats_$${c}_z88int.bin -m || exit 1; \
	  sh ./check_floats.sh -mz80 floats_$${c}_z88int.bin floats_$${c}_z88int.map $$c-z88int z88int || exit 1; \
	  zcc +test -vn -compiler=$$c -debug --math48 -c floats_a.c -o floats_a_$$c.o || exit 1; \
	  zcc +test -vn -compiler=$$c -debug --math32 -c floats_b.c -o floats_b_$$c.o || exit 1; \
	  zcc +test -vn -compiler=$$c -debug --math48 floats_a_$$c.o floats_b_$$c.o floats_n.c -o floats_$${c}_mixed.bin -m || exit 1; \
	  sh ./check_floats.sh -mz80 floats_$${c}_mixed.bin floats_$${c}_mixed.map $$c-mixed mixed || exit 1; \
	  zcc +test -vn -compiler=$$c -debug --math48 floats_p.c -o floats_$${c}_nowidth.bin -m || exit 1; \
	  sh ./check_floats.sh -mz80 floats_$${c}_nowidth.bin floats_$${c}_nowidth.map $$c-nowidth nowidth || exit 1; \
	  sh ./check_fpkinds.sh $$c || exit 1; \
	done

clean: clean-enums
clean-enums:
	$(RM) dupname/*.o dupname/*/*.o enums_a_*.asm fpkinds_*.asm
