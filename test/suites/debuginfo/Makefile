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
all: z80 i8080 i8085 gbz80
endif

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

clean:
	$(RM) *.bin *.map *.o *.sym *.def zcc_opt.def *.lis

.PHONY: all z80 i8080 i8085 gbz80 clean
