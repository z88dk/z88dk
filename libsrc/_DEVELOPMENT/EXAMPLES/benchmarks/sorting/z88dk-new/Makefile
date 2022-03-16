
.PHONY: all clean

SOURCES += $(wildcard *.c)

all:	benchmark.txt

STYLES_VAL=0 1 2 3
STYLES_NAME=ran ord rev equ

# CFLAGS +=

# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif

MACHINE = z88dk-ticks$(EXESUFFIX) -counter 999999999999

define compile_newlib_sccz80	# arg1 = binary name w/o extension, arg2 = extra defines, arg3 = extra linking options
	zcc +z80 -vn -startup=0 $(2) $(CFLAGS) -clib=new -O2 $< -o $(1) $(3) -m -create-app
	@rm $(1)_CODE.bin $(1)_UNASSIGNED.bin
endef

define compile_newlib_zsdcc	# arg1 = binary name w/o extension, arg2 = extra defines, arg3 = extra linking options
	zcc +z80 -vn -startup=0 $(2) $(CFLAGS) -clib=sdcc_iy -SO3 --max-allocs-per-node200000 $< -o $(1) $(3) -m -create-app
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

benchmark.txt: sort.c Makefile
	@echo `date +"%Y-%m-%d %H:%M:%S"` " Starting test\n" > $@
	@echo "classic / sccz80\n`tail -1 ../../../../../../src/config.h`\n" >> $@
	$(foreach NUM,20 5000,$(call benchmark_styles,sccz80,$(NUM)))
	@echo "classic / zsdcc\n`z88dk-zsdcc --version | grep Build`\n" >> $@
	$(foreach NUM,20 5000,$(call benchmark_styles,zsdcc,$(NUM)))
	@echo `date +"%Y-%m-%d %H:%M:%S"` " Test completed" >> $@
	cat $@

clean:
	rm -f sort-*.bin sort-*.map benchmark.txt *~
