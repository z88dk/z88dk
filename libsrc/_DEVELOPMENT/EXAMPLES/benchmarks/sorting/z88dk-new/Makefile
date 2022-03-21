
.PHONY: all clean

SOURCES += $(wildcard *.c)

# the sort implementation is included directly during compilation to make it amendable by config_private.inc
# overshadowing the pre-compiled newlib data (avoiding full rebuild of newlib for each test case)
EXTRA_ASM_SOURCE = $(wildcard ../../../../stdlib/z80/sort/*.asm) asm_handwritten.asm

all:	benchmark.txt

SCCZ80_VERSION = $(shell grep -o -e 'Z88DK_VERSION.*' ../../../../../../src/config.h)
ZSDCC_VERSION = $(shell z88dk-zsdcc --version | grep Build)

STYLES_VAL=0 1 2 3
STYLES_NAME=ran ord rev equ
NUM_OPTIONS=20 5000

# quick common options
SORT_OPTS=1+0 2+0xc
# complete test (takes several minutes)
# SORT_OPTS=0+0 1+0 2+0x0 2+0x1 2+0x4 2+0x5 2+0x8 2+0x9 2+0xc 2+0xd 3+0
### the option "3+0" is not part of the newlib, and selects hand-written hard-coded quick sort
### for size=2 and uint16_t compare of elements in array (not using compare function)

# CFLAGS +=

# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

MACHINE = z88dk-ticks$(EXESUFFIX) -counter 999999999999

define compile_newlib_sccz80	# arg1 = binary name w/o extension, arg2 = extra defines, arg3 = extra linking options
	zcc +z80 -vn -startup=0 $(2) $(CFLAGS) -clib=new -O2 $(EXTRA_ASM_SOURCE) $< -o $(1) $(3) -m -create-app
	@rm $(1)_CODE.bin $(1)_UNASSIGNED.bin
endef

define compile_newlib_zsdcc	# arg1 = binary name w/o extension, arg2 = extra defines, arg3 = extra linking options
	zcc +z80 -vn -startup=0 $(2) $(CFLAGS) -clib=sdcc_iy -SO3 --max-allocs-per-node200000 $(EXTRA_ASM_SOURCE) $< -o $(1) $(3) -m -create-app
	@rm $(1)_CODE.bin $(1)_UNASSIGNED.bin
endef

define benchmark_case	# arg1 = compiler, arg2 = binary name, arg3 = extra defines, arg4 = extra linking options
	$(call compile_newlib_$(1),$(2:%.bin=%),-DTIMER $(3),$(4))
	@echo -n "$(2:%.bin=%) " >> $@
	@# run sort + verification + no timing for exit status (FAIL), if OK, run again for timing
	$(MACHINE) $(2) > /dev/null \
	&& $(MACHINE) -x $(2:%.bin=%.map) -start TIMER_START -end TIMER_STOP $(2) >> $@ \
	|| echo " FAIL" >> $@

endef

define benchmark_styles # arg1 = compiler, arg2 = numbers-count
	$(foreach STYLE_IDX,1 2 3 4,\
		$(call benchmark_case,$(1),sort-$(1)-$(word $(STYLE_IDX),$(STYLES_NAME))-$(2).bin,-DNUM=$(2) -DSTYLE=$(word $(STYLE_IDX),$(STYLES_VAL))))
	@echo "" >> $@;
endef

define benchmark_configs # arg1 = compiler, arg2 = OPT_SORT+OPT_SORT_QSORT values
	@echo "defc __CLIB_OPT_SORT = $(word 1,$(subst +, ,$(2)))\ndefc __CLIB_OPT_SORT_QSORT = $(word 2,$(subst +, ,$(2)))\n" > config_private.inc
	@cat config_private.inc
	@cat config_private.inc >> $@
	$(foreach NUM,$(NUM_OPTIONS),$(call benchmark_styles,$(1),$(NUM)))

endef

benchmark.txt: sort.c Makefile
	@echo `date +"%Y-%m-%d %H:%M:%S"` " Starting test\n" > $@
	@echo "----------------------------------------------------------------------\nnew c library / sccz80\n$(SCCZ80_VERSION)\n"
	@echo "----------------------------------------------------------------------\nnew c library / sccz80\n$(SCCZ80_VERSION)\n" >> $@
	$(foreach S_OPTS,$(SORT_OPTS),$(call benchmark_configs,sccz80,$(S_OPTS)))
	@echo "----------------------------------------------------------------------\nnew c library / zsdcc\n$(ZSDCC_VERSION)\n"
	@echo "----------------------------------------------------------------------\nnew c library / zsdcc\n$(ZSDCC_VERSION)\n" >> $@
	$(foreach S_OPTS,$(SORT_OPTS),$(call benchmark_configs,zsdcc,$(S_OPTS)))
	@echo `date +"%Y-%m-%d %H:%M:%S"` " Test completed" >> $@
	@rm config_private.inc
	cat $@

clean:
	rm -f sort-*.bin sort-*.tap sort-*.map config_private.inc benchmark.txt *~
