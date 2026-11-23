# ZX Next intrinsic stage (#2757).
#
# Sources only. This directory is not in test/suites/Makefile: the checks
# need z88dk-zsdcc on PATH and they do not run under ticks.
#
# Each recipe must assemble, must contain nextreg or the register port
# sequence, and must not leave a call or jp to a ZXN intrinsic.

include ../make.config

SRC = zxn_intrinsic.c
ROOT := $(abspath ../../..)

.PHONY: all clean copt-rules

all: copt-rules compilers

copt-rules:
	@mkdir -p build
	z88dk-copt -mz80n $(ROOT)/lib/sdcc/sdcc_opt.9 < defc_alias.asm > build/defc_alias.opt
	z88dk-copt -mz80n $(ROOT)/lib/arch/z80n/z80n_intrinsic < call_scc.asm > build/call_scc.opt
	@grep -q 'nextreg' build/defc_alias.opt
	@grep -q '0x243b' build/defc_alias.opt
	@if grep -E 'ZXN_' build/defc_alias.opt; then echo "defc alias still names ZXN"; exit 1; fi
	@grep -q 'nextreg' build/call_scc.opt
	@grep -q '0x243b' build/call_scc.opt
	@if grep -E 'call[[:space:]]+_?ZXN_|jp[[:space:]]+_?ZXN_' build/call_scc.opt; then echo "scc call not expanded"; exit 1; fi
	@echo "copt-rules ok"

define compile_one
	@echo "=== $(1) ==="
	@mkdir -p build
	@rm -f build/$(2).asm build/$(2).o build/$(2).err
	zcc +zxn -a $(1) $(SRC) -o build/$(2).asm
	@if grep -E 'call[[:space:]]+_?ZXN_|jp[[:space:]]+_?ZXN_' build/$(2).asm; then echo "$(1): intrinsic call remains"; exit 1; fi
	@grep -E -q 'nextreg|0x243b' build/$(2).asm
	zcc +zxn -c $(1) $(SRC) -o build/$(2).o
	@echo "$(1) ok"
endef

compilers: copt-rules
	@mkdir -p build
	$(call compile_one,-compiler=sccz80 -clib=classic -O0,scc_classic_O0)
	$(call compile_one,-compiler=sccz80 -clib=classic -O3,scc_classic_O3)
	$(call compile_one,-compiler=sccz80 -clib=new -O3,scc_new_O3)
	$(call compile_one,-compiler=80cc -clib=classic -O2,cc80_classic)
	$(call compile_one,-compiler=80cc -clib=new -O2,cc80_new)
	$(call compile_one,-clib=sdcc_iy -O2 -SO0,sdcc_SO0)
	$(call compile_one,-clib=sdcc_iy -O2 -SO1,sdcc_SO1)
	$(call compile_one,-clib=sdcc_iy -O2 -SO2,sdcc_SO2)
	$(call compile_one,-clib=sdcc_iy -O2 -SO3,sdcc_SO3)
	$(call compile_one,-clib=sdcc_iy -O2 -SO3 --opt-code-size,sdcc_SO3_size)

clean:
	$(RM) -r build
