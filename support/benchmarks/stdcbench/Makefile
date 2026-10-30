# stdcbench 0.8, classic and newlib.
#
#   make            time the published matrix
#   make classic    Z80, four compilers
#   make new        newlib Z80, four compilers
#   make cpus       the other +test clibs, and newlib z180 / zxn
#   make 8085       sccz80 c90base only
#   make clean
#
# Each job writes build/<name>/ticks. make -j is safe: every job has
# its own directory and TMPDIR.
#
# Newlib c90lib calls realloc. Build that target with the fast
# allocator before `make new` or `make cpus`. Set __CLIB_OPT_MALLOC
# to 1 in the target config_clib.m4 (z80, z180, or zxn), remove that
# target's obj directory, then `make -C libsrc/newlib <target>`.
# c90base does not call malloc.
# 80cc is the stack-pointer build (the default). 80cc-fp passes
# -fframe-pointer. 8080, 8085, gbz80, and vm1 are not given that flag.
# Those four clibs have no qsort, so they build c90base only.
# The Z80 target names stay classic-<compiler>-* and new-<compiler>-*.
# Other CPUs are classic-<cpu>-<compiler>-* and new-<cpu>-<compiler>-*.

ROOT  := $(abspath .)
CSRC  := $(wildcard $(ROOT)/*.c)
SRC   := $(CSRC) $(wildcard $(ROOT)/*.h) \
	$(ROOT)/z88dk-classic/portme.c $(ROOT)/z88dk-classic/portme.h \
	$(ROOT)/z88dk-new/portme.c $(ROOT)/z88dk-new/portme.h \
	$(ROOT)/z88dk-new/zpragma.inc
BUILD := build

.PHONY: all classic new cpus 8085 clean

all: classic new cpus

classic: \
	$(BUILD)/classic-sccz80-c90base/ticks \
	$(BUILD)/classic-sccz80-c90lib/ticks \
	$(BUILD)/classic-80cc-c90base/ticks \
	$(BUILD)/classic-80cc-c90lib/ticks \
	$(BUILD)/classic-80cc-fp-c90base/ticks \
	$(BUILD)/classic-80cc-fp-c90lib/ticks \
	$(BUILD)/classic-zsdcc-c90base/ticks \
	$(BUILD)/classic-zsdcc-c90lib/ticks \
	$(BUILD)/classic-sccz80-iotimer/ticks \
	$(BUILD)/classic-80cc-iotimer/ticks \
	$(BUILD)/classic-80cc-fp-iotimer/ticks \
	$(BUILD)/classic-zsdcc-iotimer/ticks

new: \
	$(BUILD)/new-sccz80-c90base/ticks \
	$(BUILD)/new-sccz80-c90lib/ticks \
	$(BUILD)/new-80cc-c90base/ticks \
	$(BUILD)/new-80cc-c90lib/ticks \
	$(BUILD)/new-80cc-fp-c90base/ticks \
	$(BUILD)/new-80cc-fp-c90lib/ticks \
	$(BUILD)/new-zsdcc-c90base/ticks \
	$(BUILD)/new-zsdcc-c90lib/ticks \
	$(BUILD)/new-sccz80-iotimer/ticks \
	$(BUILD)/new-80cc-iotimer/ticks \
	$(BUILD)/new-80cc-fp-iotimer/ticks \
	$(BUILD)/new-zsdcc-iotimer/ticks

8085: $(BUILD)/classic-8085-c90base/ticks

# $(1) slug   $(2) zcc CPU fragment   $(3) ticks -m flag
define ADD_CLASSIC_BASE
$(eval $(call RUN,classic-$(1)-sccz80-c90base,\
	+test $(2) -vn -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,base,plain,$(3)))
$(eval $(call RUN,classic-$(1)-80cc-c90base,\
	+test $(2) -compiler=80cc -vn -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,base,plain,$(3)))
endef

define ADD_CLASSIC_FRAME
$(eval $(call RUN,classic-$(1)-80cc-fp-c90base,\
	+test $(2) -compiler=80cc -fframe-pointer -vn -O2 -D__Z88DK -DTIMER \
	-DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,base,plain,$(3)))
endef

define ADD_CLASSIC_LIB
$(eval $(call RUN,classic-$(1)-sccz80-c90lib,\
	+test $(2) -vn -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,lib,plain,$(3)))
$(eval $(call RUN,classic-$(1)-80cc-c90lib,\
	+test $(2) -compiler=80cc -vn -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,lib,plain,$(3)))
$(eval $(call RUN,classic-$(1)-sccz80-iotimer,\
	+test $(2) -vn -O2 -D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),$(4),io,plain,$(3)))
$(eval $(call RUN,classic-$(1)-80cc-iotimer,\
	+test $(2) -compiler=80cc -vn -O2 -D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),$(4),io,plain,$(3)))
endef

define ADD_CLASSIC_LIB_FRAME
$(eval $(call RUN,classic-$(1)-80cc-fp-c90lib,\
	+test $(2) -compiler=80cc -fframe-pointer -vn -O2 -D__Z88DK -DTIMER \
	-DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,lib,plain,$(3)))
$(eval $(call RUN,classic-$(1)-80cc-fp-iotimer,\
	+test $(2) -compiler=80cc -fframe-pointer -vn -O2 -D__Z88DK \
	-DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),$(4),io,plain,$(3)))
endef

define ADD_CLASSIC_ZSDCC
$(eval $(call RUN,classic-$(1)-zsdcc-c90base,\
	+test $(2) -compiler=sdcc -vn -SO3 --max-allocs-per-node200000 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,base,plain,$(3)))
$(eval $(call RUN,classic-$(1)-zsdcc-c90lib,\
	+test $(2) -compiler=sdcc -vn -SO3 --max-allocs-per-node200000 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,lib,plain,$(3)))
$(eval $(call RUN,classic-$(1)-zsdcc-iotimer,\
	+test $(2) -compiler=sdcc -vn -SO3 --max-allocs-per-node200000 \
	-D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-io,io,plain,$(3)))
endef

# sccz80 only. $(4) is classic-io or classic-size.
define ADD_CLASSIC_SCC_BASE
$(eval $(call RUN,classic-$(1)-sccz80-c90base,\
	+test $(2) -vn -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,base,plain,$(3)))
endef

define ADD_CLASSIC_SCC_LIB
$(eval $(call RUN,classic-$(1)-sccz80-c90lib,\
	+test $(2) -vn -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,lib,plain,$(3)))
$(eval $(call RUN,classic-$(1)-sccz80-iotimer,\
	+test $(2) -vn -O2 -D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),$(4),io,plain,$(3)))
endef

# 80cc c90lib and iotimer. c90base and the frame c90base come from the other macros.
define ADD_CLASSIC_80CC_LIB
$(eval $(call RUN,classic-$(1)-80cc-c90lib,\
	+test $(2) -compiler=80cc -vn -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,lib,plain,$(3)))
$(eval $(call RUN,classic-$(1)-80cc-iotimer,\
	+test $(2) -compiler=80cc -vn -O2 -D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),$(4),io,plain,$(3)))
endef

# $(1) slug   $(2) +target   $(3) ticks -m flag   $(4) pragma file   $(5) extra zcc
define ADD_NEW
$(eval $(call RUN,new-$(1)-sccz80-c90base,\
	$(2) $(5) -vn -startup=0 -clib=new -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT) $(ROOT)/z88dk-new/bench_io.asm,$(subst zpragma.inc,$(4),$(NW_END)),new-timer,base,plain,$(3)))
$(eval $(call RUN,new-$(1)-sccz80-c90lib,\
	$(2) $(5) -vn -startup=0 -clib=new -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT) $(ROOT)/z88dk-new/bench_io.asm,$(subst zpragma.inc,$(4),$(NW_END)),new-timer,lib,fast,$(3)))
$(eval $(call RUN,new-$(1)-80cc-c90base,\
	$(2) $(5) -compiler=80cc -vn -startup=0 -clib=new -O2 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT) $(ROOT)/z88dk-new/bench_io.asm,$(subst zpragma.inc,$(4),$(NW_END)),new-timer,base,plain,$(3)))
$(eval $(call RUN,new-$(1)-80cc-c90lib,\
	$(2) $(5) -compiler=80cc -vn -startup=0 -clib=new -O2 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT) $(ROOT)/z88dk-new/bench_io.asm,$(subst zpragma.inc,$(4),$(NW_END)),new-timer,lib,fast,$(3)))
$(eval $(call RUN,new-$(1)-80cc-fp-c90base,\
	$(2) $(5) -compiler=80cc -fframe-pointer -vn -startup=0 -clib=new -O2 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT) $(ROOT)/z88dk-new/bench_io.asm,$(subst zpragma.inc,$(4),$(NW_END)),new-timer,base,plain,$(3)))
$(eval $(call RUN,new-$(1)-80cc-fp-c90lib,\
	$(2) $(5) -compiler=80cc -fframe-pointer -vn -startup=0 -clib=new -O2 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT) $(ROOT)/z88dk-new/bench_io.asm,$(subst zpragma.inc,$(4),$(NW_END)),new-timer,lib,fast,$(3)))
$(eval $(call RUN,new-$(1)-zsdcc-c90base,\
	$(2) $(5) -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT) $(ROOT)/z88dk-new/bench_io.asm,$(subst zpragma.inc,$(4),$(NW_END)),new-timer,base,plain,$(3)))
$(eval $(call RUN,new-$(1)-zsdcc-c90lib,\
	$(2) $(5) -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT) $(ROOT)/z88dk-new/bench_io.asm,$(subst zpragma.inc,$(4),$(NW_END)),new-timer,lib,fast,$(3)))
$(eval $(call RUN,new-$(1)-sccz80-iotimer,\
	$(2) $(5) -vn -startup=0 -clib=new -O2 -D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT) $(ROOT)/z88dk-new/bench_io.asm,$(subst zpragma.inc,$(4),$(NW_END)),new-io,io,fast,$(3)))
$(eval $(call RUN,new-$(1)-80cc-iotimer,\
	$(2) $(5) -compiler=80cc -vn -startup=0 -clib=new -O2 \
	-D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT) $(ROOT)/z88dk-new/bench_io.asm,$(subst zpragma.inc,$(4),$(NW_END)),new-io,io,fast,$(3)))
$(eval $(call RUN,new-$(1)-80cc-fp-iotimer,\
	$(2) $(5) -compiler=80cc -fframe-pointer -vn -startup=0 -clib=new -O2 \
	-D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT) $(ROOT)/z88dk-new/bench_io.asm,$(subst zpragma.inc,$(4),$(NW_END)),new-io,io,fast,$(3)))
$(eval $(call RUN,new-$(1)-zsdcc-iotimer,\
	$(2) $(5) -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 \
	-D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT) $(ROOT)/z88dk-new/bench_io.asm,$(subst zpragma.inc,$(4),$(NW_END)),new-io,io,fast,$(3)))
endef

# slug|zcc-fragment|ticks-flag
# Full frame and a real iotimer run.
CLASSIC_IO := \
	z80n|-clib=z80n|-mz80n \
	z180|-clib=z180|-mz180

# Full frame. iotimer is linked for the byte count and is not emulated.
# Rabbit inp(2) does not advance the ticks clock.
CLASSIC_SIZE := \
	r4k|-clib=rabbit4k|-mr4k \
	r6k|-clib=rabbit6k|-mr6k

# Frame c90lib failed its self-check. c90base frame stays. Fourth field is the iotimer kind.
CLASSIC_NOFP := \
	ez80_z80|-clib=ez80_z80|-mez80_z80|classic-io \
	r2ka|-clib=r2ka|-mr2ka|classic-size

CLASSIC_KC160 := kc160|-clib=kc160|-mkc160
CLASSIC_R800 := r800|-clib=r800|-mr800

CLASSIC_BASE := \
	8080|-clib=8080|-m8080 \
	gbz80|-clib=gbz80|-mgbz80 \
	vm1|-clib=vm1|-mvm1

CLASSIC_ZSDCC := \
	z80n|-clib=z80n|-mz80n \
	z180|-clib=z180|-mz180

# slug|+target|ticks-flag|pragma-file|extra zcc
NEW_CPUS := \
	z180|+z180|-mz180|zpragma.inc| \
	z80n|+zxn|-mz80n|zxn.inc|-subtype=bin

# $(1) name
# $(2) zcc args before the sources
# $(3) portme.c
# $(4) zcc args after the sources
# $(5) classic-timer | new-timer | classic-io | classic-size | new-io | 8085-timer
# $(6) base | lib | io
# $(7) fast | plain
# $(8) ticks CPU flag, placed before the binary. Empty on Z80.
define RUN
$(BUILD)/$(1)/ticks: $$(SRC) $(ROOT)/Makefile $(3) $(ROOT)/z88dk-new/zpragma.inc
	@mkdir -p $(ROOT)/$(BUILD)/$(1)/tmp
	@echo "[-] $(1)"
	cd $(ROOT)/$(BUILD)/$(1) && TMPDIR=$(ROOT)/$(BUILD)/$(1)/tmp \
		zcc $(2) $(CSRC) $(3) $(4)
	cd $(ROOT)/$(BUILD)/$(1) && \
	if [ "$(7)" = fast ]; then \
		if grep -q asm_heap_realloc_unlocked_small stdcbench.map \
		   || ! grep -q asm_heap_realloc_unlocked_fast stdcbench.map; then \
			echo "c90lib needs newlib built with __CLIB_OPT_MALLOC = 1" >&2; \
			echo "Edit that target config_clib.m4 (z80, z180, or zxn)" >&2; \
			echo "rm -rf libsrc/newlib/target/<target>/obj" >&2; \
			echo "make -C libsrc/newlib <target>" >&2; \
			exit 1; \
		fi; \
	fi && \
	rm -f stdcbench_CODE.bin stdcbench_DATA.bin stdcbench_BSS.bin \
		stdcbench_UNASSIGNED.bin && \
	if [ -s stdcbench__.bin ]; then cp -f stdcbench__.bin stdcbench.bin; fi && \
	if [ ! -s stdcbench.bin ]; then cp -f "`ls -1 stdcbench*.bin | head -1`" stdcbench.bin; fi && \
	org=`awk '$$$$1=="__crt_org_code"{print $$$$3; exit}' stdcbench.map`; \
	org=$$$${org#$$$$}; \
	if [ -z "$$$$org" ]; then org=0; fi && \
	case "$(5)" in \
	classic-timer) \
		timeout 900 z88dk-ticks $(8) stdcbench.bin -x stdcbench.map \
			-start TIMER_START -end TIMER_STOP \
			-counter 999999999999 > ticks.txt ;; \
	8085-timer) \
		timeout 900 z88dk-ticks -m8085 stdcbench.bin -x stdcbench.map \
			-start TIMER_START -end TIMER_STOP \
			-counter 999999999999 > ticks.txt ;; \
	new-timer) \
		timeout 900 z88dk-ticks $(8) -l 0x$$$$org -iochar 1 stdcbench.bin -x stdcbench.map \
			-start TIMER_START -end TIMER_STOP \
			-counter 999999999999 > ticks.txt ;; \
	classic-io) \
		timeout 900 z88dk-ticks $(8) -x stdcbench.map -iotimer 2 -mmtimer _tickbuf \
			-counter 999999999999 stdcbench.bin > ticks.txt ;; \
	classic-size) \
		: > ticks.txt ;; \
	new-io) \
		end=9e; \
		if [ -n "$(8)" ]; then \
			end=`ORG=0x$$$$org python3 -c 'import os,pathlib,sys; b=pathlib.Path("stdcbench.bin").read_bytes(); i=b.find(bytes([0x76,0x18,0xfe])); sys.exit("no halt") if i<0 else print("%x"%(i+int(os.environ["ORG"],16)))'`; \
		fi; \
		timeout 900 z88dk-ticks $(8) -l 0x$$$$org -iochar 1 -x stdcbench.map -end $$$$end \
			-iotimer 2 -mmtimer _tickbuf \
			-counter 999999999999 stdcbench.bin > ticks.txt ;; \
	esac
	cd $(ROOT)/$(BUILD)/$(1) && \
	bytes=`wc -c < stdcbench.bin | tr -d ' '` && \
	if [ "$(6)" = io ]; then \
		echo "$(1) bytes=$$$$bytes iotimer" | tee ticks; \
	else \
		cycles=`awk 'NF==1 && $$$$1 ~ /^[0-9]+$$$$/ {n=$$$$1} END {print n}' ticks.txt` && \
		if [ "$(6)" = lib ]; then numer=4000000; else numer=800000; fi && \
		elapsed=`expr $$$$cycles / 40` && \
		score=`awk "BEGIN { printf \"%.1f\", (1000 * $$$$numer / $$$$elapsed) / 100 }"` && \
		echo "$(1) bytes=$$$$bytes ticks=$$$$cycles score=$$$$score" | tee ticks; \
	fi
	@echo "[-] $(1) done"
endef

CL_END := -o stdcbench.bin -lndos -m -pragma-define:CRT_HEAP_AMALLOC=1
NW_END := -o stdcbench -m -pragma-include:$(ROOT)/z88dk-new/zpragma.inc -create-app
CL_PORT := $(ROOT)/z88dk-classic/portme.c
NW_PORT := $(ROOT)/z88dk-new/portme.c

$(eval $(call RUN,classic-sccz80-c90base,\
	+test -vn -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,base,plain))

$(eval $(call RUN,classic-sccz80-c90lib,\
	+test -vn -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,lib,plain))

$(eval $(call RUN,classic-80cc-c90base,\
	+test -compiler=80cc -vn -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,base,plain))

$(eval $(call RUN,classic-80cc-c90lib,\
	+test -compiler=80cc -vn -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,lib,plain))

$(eval $(call RUN,classic-80cc-fp-c90base,\
	+test -compiler=80cc -fframe-pointer -vn -O2 -D__Z88DK -DTIMER \
	-DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,base,plain))

$(eval $(call RUN,classic-80cc-fp-c90lib,\
	+test -compiler=80cc -fframe-pointer -vn -O2 -D__Z88DK -DTIMER \
	-DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,lib,plain))

$(eval $(call RUN,classic-zsdcc-c90base,\
	+test -compiler=sdcc -vn -SO3 --max-allocs-per-node200000 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,base,plain))

$(eval $(call RUN,classic-zsdcc-c90lib,\
	+test -compiler=sdcc -vn -SO3 --max-allocs-per-node200000 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,lib,plain))

$(eval $(call RUN,classic-sccz80-iotimer,\
	+test -vn -O2 -D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-io,io,plain))

$(eval $(call RUN,classic-80cc-iotimer,\
	+test -compiler=80cc -vn -O2 -D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-io,io,plain))

$(eval $(call RUN,classic-80cc-fp-iotimer,\
	+test -compiler=80cc -fframe-pointer -vn -O2 -D__Z88DK \
	-DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-io,io,plain))

$(eval $(call RUN,classic-zsdcc-iotimer,\
	+test -compiler=sdcc -vn -SO3 --max-allocs-per-node200000 \
	-D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-io,io,plain))

$(eval $(call RUN,classic-8085-c90base,\
	+test -clib=8085 -vn -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),8085-timer,base,plain))

$(eval $(call RUN,new-sccz80-c90base,\
	+z80 -vn -startup=0 -clib=new -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT),$(NW_END),new-timer,base,plain))

$(eval $(call RUN,new-sccz80-c90lib,\
	+z80 -vn -startup=0 -clib=new -O2 -D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT),$(NW_END),new-timer,lib,fast))

$(eval $(call RUN,new-80cc-c90base,\
	+z80 -compiler=80cc -vn -startup=0 -clib=new -O2 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT),$(NW_END),new-timer,base,plain))

$(eval $(call RUN,new-80cc-c90lib,\
	+z80 -compiler=80cc -vn -startup=0 -clib=new -O2 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT),$(NW_END),new-timer,lib,fast))

$(eval $(call RUN,new-80cc-fp-c90base,\
	+z80 -compiler=80cc -fframe-pointer -vn -startup=0 -clib=new -O2 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT),$(NW_END),new-timer,base,plain))

$(eval $(call RUN,new-80cc-fp-c90lib,\
	+z80 -compiler=80cc -fframe-pointer -vn -startup=0 -clib=new -O2 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT),$(NW_END),new-timer,lib,fast))

$(eval $(call RUN,new-zsdcc-c90base,\
	+z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT),$(NW_END),new-timer,base,plain))

$(eval $(call RUN,new-zsdcc-c90lib,\
	+z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 \
	-D__Z88DK -DTIMER -DSTDCBENCH_WHICH=2 \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT),$(NW_END),new-timer,lib,fast))

$(eval $(call RUN,new-sccz80-iotimer,\
	+z80 -vn -startup=0 -clib=new -O2 -D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT),$(NW_END),new-io,io,fast))

$(eval $(call RUN,new-80cc-iotimer,\
	+z80 -compiler=80cc -vn -startup=0 -clib=new -O2 \
	-D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT),$(NW_END),new-io,io,fast))

$(eval $(call RUN,new-80cc-fp-iotimer,\
	+z80 -compiler=80cc -fframe-pointer -vn -startup=0 -clib=new -O2 \
	-D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT),$(NW_END),new-io,io,fast))

$(eval $(call RUN,new-zsdcc-iotimer,\
	+z80 -vn -startup=0 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 \
	-D__Z88DK -DSTDCBENCH_IOTIMER \
	-I$(ROOT) -I$(ROOT)/z88dk-new,\
	$(NW_PORT),$(NW_END),new-io,io,fast))

split = $(subst |, ,$(1))
W1 = $(word 1,$(call split,$(1)))
W2 = $(word 2,$(call split,$(1)))
W3 = $(word 3,$(call split,$(1)))
W4 = $(word 4,$(call split,$(1)))
W5 = $(word 5,$(call split,$(1)))

$(foreach spec,$(CLASSIC_IO),\
	$(eval $(call ADD_CLASSIC_BASE,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec))))\
	$(eval $(call ADD_CLASSIC_FRAME,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec))))\
	$(eval $(call ADD_CLASSIC_LIB,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec)),classic-io))\
	$(eval $(call ADD_CLASSIC_LIB_FRAME,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec)),classic-io)))

$(foreach spec,$(CLASSIC_SIZE),\
	$(eval $(call ADD_CLASSIC_BASE,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec))))\
	$(eval $(call ADD_CLASSIC_FRAME,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec))))\
	$(eval $(call ADD_CLASSIC_LIB,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec)),classic-size))\
	$(eval $(call ADD_CLASSIC_LIB_FRAME,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec)),classic-size)))

$(foreach spec,$(CLASSIC_NOFP),\
	$(eval $(call ADD_CLASSIC_BASE,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec))))\
	$(eval $(call ADD_CLASSIC_FRAME,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec))))\
	$(eval $(call ADD_CLASSIC_LIB,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec)),$(call W4,$(spec)))))

$(foreach spec,$(CLASSIC_KC160),\
	$(eval $(call ADD_CLASSIC_BASE,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec))))\
	$(eval $(call ADD_CLASSIC_FRAME,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec))))\
	$(eval $(call ADD_CLASSIC_80CC_LIB,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec)),classic-io))\
	$(eval $(call ADD_CLASSIC_LIB_FRAME,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec)),classic-io)))

$(foreach spec,$(CLASSIC_R800),\
	$(eval $(call ADD_CLASSIC_SCC_BASE,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec))))\
	$(eval $(call ADD_CLASSIC_SCC_LIB,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec)),classic-io)))

$(foreach spec,$(CLASSIC_BASE),\
	$(eval $(call ADD_CLASSIC_BASE,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec)))))

$(foreach spec,$(CLASSIC_ZSDCC),\
	$(eval $(call ADD_CLASSIC_ZSDCC,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec)))))

$(foreach spec,$(NEW_CPUS),\
	$(eval $(call ADD_NEW,$(call W1,$(spec)),$(call W2,$(spec)),$(call W3,$(spec)),$(call W4,$(spec)),$(call W5,$(spec)))))

$(eval $(call RUN,classic-8085-80cc-c90base,\
	+test -clib=8085 -compiler=80cc -vn -O2 -D__Z88DK -DTIMER \
	-DSTDCBENCH_WHICH=1 \
	-I$(ROOT) -I$(ROOT)/z88dk-classic,\
	$(CL_PORT),$(CL_END),classic-timer,base,plain,-m8085))

cpus: \
	$(foreach spec,$(CLASSIC_IO) $(CLASSIC_SIZE),\
		$(BUILD)/classic-$(call W1,$(spec))-sccz80-c90base/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-sccz80-c90lib/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-sccz80-iotimer/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-c90base/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-c90lib/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-iotimer/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-fp-c90base/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-fp-c90lib/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-fp-iotimer/ticks) \
	$(foreach spec,$(CLASSIC_NOFP),\
		$(BUILD)/classic-$(call W1,$(spec))-sccz80-c90base/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-sccz80-c90lib/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-sccz80-iotimer/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-c90base/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-c90lib/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-iotimer/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-fp-c90base/ticks) \
	$(foreach spec,$(CLASSIC_KC160),\
		$(BUILD)/classic-$(call W1,$(spec))-sccz80-c90base/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-c90base/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-c90lib/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-iotimer/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-fp-c90base/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-fp-c90lib/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-fp-iotimer/ticks) \
	$(foreach spec,$(CLASSIC_R800),\
		$(BUILD)/classic-$(call W1,$(spec))-sccz80-c90base/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-sccz80-c90lib/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-sccz80-iotimer/ticks) \
	$(foreach spec,$(CLASSIC_BASE),\
		$(BUILD)/classic-$(call W1,$(spec))-sccz80-c90base/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-80cc-c90base/ticks) \
	$(foreach spec,$(CLASSIC_ZSDCC),\
		$(BUILD)/classic-$(call W1,$(spec))-zsdcc-c90base/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-zsdcc-c90lib/ticks \
		$(BUILD)/classic-$(call W1,$(spec))-zsdcc-iotimer/ticks) \
	$(BUILD)/classic-8085-c90base/ticks \
	$(BUILD)/classic-8085-80cc-c90base/ticks \
	$(foreach spec,$(NEW_CPUS),\
		$(BUILD)/new-$(call W1,$(spec))-sccz80-c90base/ticks \
		$(BUILD)/new-$(call W1,$(spec))-sccz80-c90lib/ticks \
		$(BUILD)/new-$(call W1,$(spec))-sccz80-iotimer/ticks \
		$(BUILD)/new-$(call W1,$(spec))-80cc-c90base/ticks \
		$(BUILD)/new-$(call W1,$(spec))-80cc-c90lib/ticks \
		$(BUILD)/new-$(call W1,$(spec))-80cc-iotimer/ticks \
		$(BUILD)/new-$(call W1,$(spec))-80cc-fp-c90base/ticks \
		$(BUILD)/new-$(call W1,$(spec))-80cc-fp-c90lib/ticks \
		$(BUILD)/new-$(call W1,$(spec))-80cc-fp-iotimer/ticks \
		$(BUILD)/new-$(call W1,$(spec))-zsdcc-c90base/ticks \
		$(BUILD)/new-$(call W1,$(spec))-zsdcc-c90lib/ticks \
		$(BUILD)/new-$(call W1,$(spec))-zsdcc-iotimer/ticks)

clean:
	rm -rf $(BUILD)
