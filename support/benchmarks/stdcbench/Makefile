# stdcbench 0.8, classic and newlib, Z80.
#
#   make            time the published matrix
#   make classic
#   make new
#   make 8085       sccz80 c90base only
#   make clean
#
# Each job writes build/<name>/ticks. make -j is safe: every job has
# its own directory and TMPDIR.
#
# Newlib c90lib calls realloc. Build the z80 newlib with the fast
# allocator before `make new`. In
# libsrc/newlib/target/z80/config/config_clib.m4 set
# __CLIB_OPT_MALLOC to 1, remove
# libsrc/newlib/target/z80/obj/config_private.inc, then
# `make -C libsrc/newlib z80`. That refreshes sccz80/z80.lib and
# sdcc_ix/z80.lib. c90base does not call malloc.
# 80cc is the stack-pointer build (the default). 80cc-fp passes
# -fframe-pointer. 8085 is not given that flag.

ROOT  := $(abspath .)
CSRC  := $(wildcard $(ROOT)/*.c)
SRC   := $(CSRC) $(wildcard $(ROOT)/*.h) \
	$(ROOT)/z88dk-classic/portme.c $(ROOT)/z88dk-classic/portme.h \
	$(ROOT)/z88dk-new/portme.c $(ROOT)/z88dk-new/portme.h \
	$(ROOT)/z88dk-new/zpragma.inc
BUILD := build

.PHONY: all classic new 8085 clean

all: classic new

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

# $(1) name
# $(2) zcc args before the sources
# $(3) portme.c
# $(4) zcc args after the sources
# $(5) classic-timer | new-timer | classic-io | new-io | 8085-timer
# $(6) base | lib | io
# $(7) fast | plain
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
			echo "Edit libsrc/newlib/target/z80/config/config_clib.m4" >&2; \
			echo "rm -f libsrc/newlib/target/z80/obj/config_private.inc" >&2; \
			echo "make -C libsrc/newlib z80" >&2; \
			exit 1; \
		fi; \
	fi && \
	rm -f stdcbench_CODE.bin stdcbench_DATA.bin stdcbench_BSS.bin \
		stdcbench_UNASSIGNED.bin && \
	case "$(5)" in \
	classic-timer) \
		z88dk-ticks stdcbench.bin -x stdcbench.map \
			-start TIMER_START -end TIMER_STOP \
			-counter 999999999999 > ticks.txt ;; \
	8085-timer) \
		z88dk-ticks -m8085 stdcbench.bin -x stdcbench.map \
			-start TIMER_START -end TIMER_STOP \
			-counter 999999999999 > ticks.txt ;; \
	new-timer) \
		z88dk-ticks -iochar 1 stdcbench.bin -x stdcbench.map \
			-start TIMER_START -end TIMER_STOP \
			-counter 999999999999 > ticks.txt ;; \
	classic-io) \
		z88dk-ticks -x stdcbench.map -iotimer 2 -mmtimer _tickbuf \
			-counter 999999999999 stdcbench.bin > ticks.txt ;; \
	new-io) \
		z88dk-ticks -iochar 1 -x stdcbench.map -end 9e \
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

clean:
	rm -rf $(BUILD)
