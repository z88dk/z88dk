include ../make.config

# Rabbit logical-to-physical mapping under z88dk-ticks: SEGSIZE/DATASEG/
# STACKSEG segments, the XPC window, ldp, lcall/ljp/lret.
# mmu.asm leaves its results in root memory at 0x100.

CPUS = r2ka r3k r4k

# Result bytes at 0x100..0x10d, little endian words / bytes
EXPECTED = ef be fe ca aa 55 83 11 44 00 00 00 57 13

# The recipes are POSIX shell (sh, od, sed, grep) and the debugger tests script
# z88dk-ticks over stdin. They do not run under Windows shells
# (cygwin/mingw/msys), so skip the whole suite there, compile included.
UNAME := $(shell uname -s 2>/dev/null)
RMMU_WINDOWS :=
ifeq ($(OS),Windows_NT)
RMMU_WINDOWS := 1
endif
ifneq (,$(findstring CYGWIN,$(UNAME)))
RMMU_WINDOWS := 1
endif
ifneq (,$(findstring MINGW,$(UNAME)))
RMMU_WINDOWS := 1
endif
ifneq (,$(findstring MSYS,$(UNAME)))
RMMU_WINDOWS := 1
endif

ifdef RMMU_WINDOWS
all:
	@echo "rabbit_mmu: skipped (POSIX-shell recipes; not run on Windows)"
else
all: $(addprefix run_,$(CPUS)) $(addprefix run4k_,r4k r6k) $(addprefix run4kseg_,r4k r6k) $(addprefix runcrt_,$(CPUS)) $(addprefix runcrt12_,r4k r6k) banktests fartests far24tests debugtests dbglinetests dbgvartests dbgbtests dbgztests pragmatests farstrtests bankstyletests
endif

mmu.bin: mmu.asm
	z88dk-z80asm -mr3k -b mmu.asm

run_%: mmu.bin
	@z88dk-ticks -m$* -end 7e -output mmu_$*.out mmu.bin > /dev/null
	@got=$$(od -An -tx1 -j256 -N14 mmu_$*.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(EXPECTED)" ]; then \
		echo "$(GREEN)rabbit_mmu $* passed$(RESET)"; \
	else \
		echo "$(RED)rabbit_mmu $* failed: got '$$got'$(RESET)"; exit 1; \
	fi

# R4K and later: 12 bit LXPC, llcall/llret/lljp, ldf through the window.
# mmu4k.asm leaves its results at 0x100.
EXPECTED4K = bc 0a 5a 00 ef 0d 77 00 ef 0d 23 01 57 04 77 07

mmu4k.bin: mmu4k.asm
	z88dk-z80asm -mr4k -b mmu4k.asm

run4k_%: mmu4k.bin
	@z88dk-ticks -m$* -end 7f -output mmu4k_$*.out mmu4k.bin > /dev/null
	@got=$$(od -An -tx1 -j256 -N16 mmu4k_$*.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(EXPECTED4K)" ]; then \
		echo "$(GREEN)rabbit_mmu 4k $* passed$(RESET)"; \
	else \
		echo "$(RED)rabbit_mmu 4k $* failed: got '$$got'$(RESET)"; exit 1; \
	fi

# R4K and later: 12 bit DATSEG/STKSEG offsets through the L and H registers,
# DATASEG as the 8 bit alias. mmu4k_seg.asm leaves its results at 0x100.
EXPECTED4KSEG = 77 88 99 10 00

mmu4k_seg.bin: mmu4k_seg.asm
	z88dk-z80asm -mr4k -b mmu4k_seg.asm

run4kseg_%: mmu4k_seg.bin
	@z88dk-ticks -m$* -end 5f -output mmu4k_seg_$*.out mmu4k_seg.bin > /dev/null
	@got=$$(od -An -tx1 -j256 -N5 mmu4k_seg_$*.out | tr -s ' \n' ' ' | sed 's/^ //;s/ $$//'); \
	if [ "$$got" = "$(EXPECTED4KSEG)" ]; then \
		echo "$(GREEN)rabbit_mmu 4k seg $* passed$(RESET)"; \
	else \
		echo "$(RED)rabbit_mmu 4k seg $* failed: got '$$got'$(RESET)"; exit 1; \
	fi

# crt_init_rabbit.inc: the crt programs the MMU from CRT_RABBIT_* pragmas
CRT_CLIB_r2ka = rabbit
CRT_CLIB_r3k  = rabbit
CRT_CLIB_r4k  = rabbit4k
CRT_PRAGMAS = -pragma-define:CRT_RABBIT_SEGSIZE=0x84 \
	-pragma-define:CRT_RABBIT_DATASEG=0x10 \
	-pragma-define:CRT_RABBIT_STACKSEG=0x20 \
	-pragma-define:CRT_RABBIT_XPC=0x82

runcrt_%: crt_mmu.c
	@zcc +test -clib=$(CRT_CLIB_$*) $(CRT_PRAGMAS) crt_mmu.c -o crt_$*.bin
	@got=$$(z88dk-ticks -m$* crt_$*.bin | head -1); \
	if [ "$$got" = "xpc=82 segsize=84 dataseg=10 stackseg=20 dh=00 sh=00" ]; then \
		echo "$(GREEN)rabbit_mmu crt $* passed$(RESET)"; \
	else \
		echo "$(RED)rabbit_mmu crt $* failed: got '$$got'$(RESET)"; exit 1; \
	fi

# Banked calls and data in three code banks (XPC = bank * 2). The banks are
# loaded after the root image by ticks -banks.
BANK_COMPILERS = sccz80 80cc
BANK_EXPECTED = 42 200 100023 6 4321 1020304

define bank_test
BANK_TESTS += runbank_$(1)_$(2)
runbank_$(1)_$(2): banked_main.c banked_b1.c banked_b2.c banked_b3.c
	@zcc +test -compiler=$(2) -clib=$$(CRT_CLIB_$(1)) -pragma-define:CRT_RABBIT_BANKS=3 banked_main.c banked_b1.c banked_b2.c banked_b3.c -o bank_$(1)_$(2).bin
	@got=$$$$(z88dk-ticks -m$(1) -banks bank_$(1)_$(2).bin | head -1); \
	if [ "$$$$got" = "$$(BANK_EXPECTED)" ]; then \
		echo "$$(GREEN)rabbit_mmu banked $(1) $(2) passed$$(RESET)"; \
	else \
		echo "$$(RED)rabbit_mmu banked $(1) $(2) failed: got '$$$$got'$$(RESET)"; exit 1; \
	fi
endef

$(foreach cpu,$(CPUS),$(foreach comp,$(BANK_COMPILERS),$(eval $(call bank_test,$(cpu),$(comp)))))

banktests: $(BANK_TESTS)

# Far pointers: 24-bit physical addresses through the XPC window. The window
# is also the top of the near address space, so the stack stays below it.
FAR_EXPECTED = 16 17 18 19 | 1234 | 11223344 | 99 3

define far_test
FAR_TESTS += runfar_$(1)_$(2)
runfar_$(1)_$(2): far_main.c
	@zcc +test -compiler=$(2) -clib=$$(CRT_CLIB_$(1)) -pragma-define:CRT_RABBIT_BANKS=0 far_main.c -o far_$(1)_$(2).bin
	@got=$$$$(z88dk-ticks -m$(1) far_$(1)_$(2).bin | head -1); \
	if [ "$$$$got" = "$$(FAR_EXPECTED)" ]; then \
		echo "$$(GREEN)rabbit_mmu far $(1) $(2) passed$$(RESET)"; \
	else \
		echo "$$(RED)rabbit_mmu far $(1) $(2) failed: got '$$$$got'$$(RESET)"; exit 1; \
	fi
endef

$(foreach cpu,$(CPUS),$(foreach comp,$(BANK_COMPILERS),$(eval $(call far_test,$(cpu),$(comp)))))

fartests: $(FAR_TESTS)

# R4K and later: the 12 bit LXPC reaches the whole 16MB space
FAR24_EXPECTED = 11112222 33334444 50 53
CRT_CLIB_r6k = rabbit6k

define far24_test
FAR24_TESTS += runfar24_$(1)_$(2)
runfar24_$(1)_$(2): far24_main.c
	@zcc +test -compiler=$(2) -clib=$$(CRT_CLIB_$(1)) -pragma-define:CRT_RABBIT_BANKS=0 far24_main.c -o far24_$(1)_$(2).bin
	@got=$$$$(z88dk-ticks -m$(1) far24_$(1)_$(2).bin | head -1); \
	if [ "$$$$got" = "$$(FAR24_EXPECTED)" ]; then \
		echo "$$(GREEN)rabbit_mmu far24 $(1) $(2) passed$$(RESET)"; \
	else \
		echo "$$(RED)rabbit_mmu far24 $(1) $(2) failed: got '$$$$got'$$(RESET)"; exit 1; \
	fi
endef

$(foreach cpu,r4k r6k,$(foreach comp,$(BANK_COMPILERS),$(eval $(call far24_test,$(cpu),$(comp)))))

far24tests: $(FAR24_TESTS)

# R4K and later: the 12 bit segment offsets go through the L and H registers
runcrt12_%: crt_mmu.c
	@zcc +test -clib=$(CRT_CLIB_$*) -pragma-define:CRT_RABBIT_SEGSIZE=0x84 \
		-pragma-define:CRT_RABBIT_DATASEG=0xa34 -pragma-define:CRT_RABBIT_STACKSEG=0x201 \
		-pragma-define:CRT_RABBIT_XPC=0x82 crt_mmu.c -o crt12_$*.bin
	@got=$$(z88dk-ticks -m$* crt12_$*.bin | head -1); \
	if [ "$$got" = "xpc=82 segsize=84 dataseg=34 stackseg=01 dh=0a sh=02" ]; then \
		echo "$(GREEN)rabbit_mmu crt 12-bit $* passed$(RESET)"; \
	else \
		echo "$(RED)rabbit_mmu crt 12-bit $* failed: got '$$got'$(RESET)"; exit 1; \
	fi

# The debugger: breakpoints on banked symbols and bank:address, the XPC line
# of reg, and x on a banked address. banked_dbg.txt is the debugger script.
DBG_XPC_r2ka = xpc=02 
DBG_XPC_r4k = xpc=002 
DBG_WXPC_r2ka = xpc=06 
DBG_WXPC_r4k = xpc=006 

define dbg_test
DBG_TESTS += rundbg_$(1)
rundbg_$(1): banked_main.c banked_b1.c banked_b2.c banked_b3.c banked_dbg.txt
	@zcc +test -compiler=sccz80 -clib=$$(CRT_CLIB_$(1)) -pragma-define:CRT_RABBIT_BANKS=3 banked_main.c banked_b1.c banked_b2.c banked_b3.c -o dbg_$(1).bin -m
	@out=$$$$(z88dk-ticks -m$(1) -banks -x dbg_$(1).map -d -script banked_dbg.txt dbg_$(1).bin 2>&1); \
	for want in 'Hit breakpoint 1: @$$$$1:$$$$E000 (_bank1_inc)' 'Hit breakpoint 2: @$$$$2:$$$$E000 (_bank2_mul)' "$$(DBG_XPC_$(1))" "1E000:   "; do \
		echo "$$$$out" | grep -qF "$$$$want" || { echo "$$(RED)rabbit_mmu debugger $(1) failed: no '$$$$want'$$(RESET)"; exit 1; }; \
	done; \
	out=$$$$(z88dk-ticks -m$(1) -banks -x dbg_$(1).map -d -script banked_watch.txt dbg_$(1).bin 2>&1); \
	for want in '(read) @$$$$3e000 (_bank3_val)' '(read) @$$$$4e000 (<unknown>)' "Hit watchpoint 1" "$$(DBG_WXPC_$(1))"; do \
		echo "$$$$out" | grep -qF -- "$$$$want" || { echo "$$(RED)rabbit_mmu watchpoint $(1) failed: no '$$$$want'$$(RESET)"; exit 1; }; \
	done; \
	echo "$$$$out" | grep -qF "Hit watchpoint 2" && { echo "$$(RED)rabbit_mmu watchpoint $(1) failed: bank 4 is not mapped$$(RESET)"; exit 1; }; \
	echo "$$(GREEN)rabbit_mmu debugger $(1) passed$$(RESET)"
endef

# Source lines in banked code: break file:line, list and next. -debug puts the
# lines in the map file as symbols with the bank in bits 16 and up.
define dbgline_test
DBGLINE_TESTS += rundbgline_$(1)_$(2)
rundbgline_$(1)_$(2): dbgl_main.c dbgl_b1.c dbgl.txt
	@zcc +test -compiler=$(2) -clib=$$(CRT_CLIB_$(1)) -debug -pragma-define:CRT_RABBIT_BANKS=1 dbgl_main.c dbgl_b1.c -o dbgl_$(1)_$(2).bin -m
	@out=$$$$(z88dk-ticks -m$(1) -banks -x dbgl_$(1)_$(2).map -d -script dbgl.txt dbgl_$(1)_$(2).bin 2>&1); \
	for want in 'Hit breakpoint 1: @$$$$1:$$$$E0' '(_bank1_inc+' '>    4:     int y = x + 1;' '>    5:     return y;'; do \
		echo "$$$$out" | grep -qF -- "$$$$want" || { echo "$$(RED)rabbit_mmu source lines $(1) $(2) failed: no '$$$$want'$$(RESET)"; exit 1; }; \
	done; \
	echo "$$(GREEN)rabbit_mmu source lines $(1) $(2) passed$$(RESET)"
endef

$(foreach cpu,r2ka r4k,$(foreach comp,$(BANK_COMPILERS),$(eval $(call dbgline_test,$(cpu),$(comp)))))

dbglinetests: $(DBGLINE_TESTS)

$(foreach cpu,r2ka r4k,$(eval $(call dbg_test,$(cpu))))

debugtests: $(DBG_TESTS)

# The other banking styles under the debugger: ZXN MMU slots 6 and 7 and MSX
# 16k pages. Each program maps a bank, copies code in, calls it and the script
# breaks in the bank with bank:address.
bankstyletests: runbank_zxn runbank_msx

runbank_zxn: bank_zxn.asm bank_zxn.txt
	@z88dk-z80asm -mz80n -b bank_zxn.asm
	@out=$$(z88dk-ticks -mz80n -d -script bank_zxn.txt bank_zxn.bin 2>&1); \
	for want in 'Hit breakpoint 1: @$$10:$$C000' "6=10 7=11" "10C000:   3E 42 C9"; do \
		echo "$$out" | grep -qF "$$want" || { echo "$(RED)rabbit_mmu zxn banks failed: no '$$want'$(RESET)"; exit 1; }; \
	done; \
	echo "$(GREEN)rabbit_mmu zxn banks passed$(RESET)"

runbank_msx: bank_msx.asm bank_msx.txt
	@z88dk-z80asm -mz80 -b bank_msx.asm
	@out=$$(z88dk-ticks -mz80 -b msx -d -script bank_msx.txt bank_msx.bin 2>&1); \
	for want in 'Hit breakpoint 1: @$$5:$$8000' "2=05" "58000:   3E 42 C9"; do \
		echo "$$out" | grep -qF "$$want" || { echo "$(RED)rabbit_mmu msx banks failed: no '$$want'$(RESET)"; exit 1; }; \
	done; \
	echo "$(GREEN)rabbit_mmu msx banks passed$(RESET)"

# #pragma bank directly followed by static and struct declarations. sccz80
# once read the first word of the next declaration as part of the pragma.
define pragma_test
PRAGMA_TESTS += runpragma_$(1)_$(2)
runpragma_$(1)_$(2): pragma_main.c pragma_b1.c
	@zcc +test -compiler=$(2) -clib=$$(CRT_CLIB_$(1)) -pragma-define:CRT_RABBIT_BANKS=1 pragma_main.c pragma_b1.c -o pragma_$(1)_$(2).bin
	@got=$$$$(z88dk-ticks -m$(1) -banks pragma_$(1)_$(2).bin | head -1); \
	if [ "$$$$got" = "43" ]; then \
		echo "$$(GREEN)rabbit_mmu pragma bank $(1) $(2) passed$$(RESET)"; \
	else \
		echo "$$(RED)rabbit_mmu pragma bank $(1) $(2) failed: got '$$$$got'$$(RESET)"; exit 1; \
	fi
endef

$(foreach cpu,r2ka r4k,$(foreach comp,$(BANK_COMPILERS),$(eval $(call pragma_test,$(cpu),$(comp)))))

pragmatests: $(PRAGMA_TESTS)

# Variables in banked code: statics, function statics, locals and a const
# array in another bank. The comparison is of the lines that print a value.
define dbgvar_test
DBGVAR_TESTS += rundbgvar_$(1)_$(2)
rundbgvar_$(1)_$(2): dbgv_main.c dbgv_b1.c dbgv_b3.c dbgv.txt dbgv.expected
	@zcc +test -compiler=$(2) -clib=$$(CRT_CLIB_$(1)) -debug -pragma-define:CRT_RABBIT_BANKS=3 dbgv_main.c dbgv_b1.c dbgv_b3.c -o dbgv_$(1)_$(2).bin -m
	@z88dk-ticks -m$(1) -banks -x dbgv_$(1)_$(2).map -d -script dbgv.txt dbgv_$(1)_$(2).bin 2>&1 | grep -F ' = <' > dbgv_$(1)_$(2).out; \
	if cmp -s dbgv_$(1)_$(2).out dbgv.expected; then \
		echo "$$(GREEN)rabbit_mmu variables $(1) $(2) passed$$(RESET)"; \
	else \
		echo "$$(RED)rabbit_mmu variables $(1) $(2) failed:$$(RESET)"; diff dbgv.expected dbgv_$(1)_$(2).out; exit 1; \
	fi
endef

$(foreach cpu,r2ka r4k,$(foreach comp,$(BANK_COMPILERS),$(eval $(call dbgvar_test,$(cpu),$(comp)))))

dbgvartests: $(DBGVAR_TESTS)

# Backtrace through banked_call: root -> bank 1 -> bank 2. The real callers and
# their banks are on the bank stack. bt, up, print and finish walk it.
define dbgb_test
DBGB_TESTS += rundbgb_$(1)_$(2)
rundbgb_$(1)_$(2): dbgb_main.c dbgb_b1.c dbgb_b2.c dbgb_bt.txt dbgb_fin.txt
	@zcc +test -compiler=$(2) -clib=$$(CRT_CLIB_$(1)) -debug -pragma-define:CRT_RABBIT_BANKS=2 dbgb_main.c dbgb_b1.c dbgb_b2.c -o dbgb_$(1)_$(2).bin -m
	@out=$$$$(z88dk-ticks -m$(1) -banks -x dbgb_$(1)_$(2).map -d -script dbgb_bt.txt dbgb_$(1)_$(2).bin 2>&1); \
	for want in 'function bank2_inner' '<int16_t>i = 11' 'function bank1_outer' '<int16_t>o = 10' 'function main' '<int16_t>m = 100' 'at dbgb_b2.c:5' 'at dbgb_b1.c:6' 'at dbgb_main.c:5' 'frame 2'; do \
		echo "$$$$out" | grep -qF -- "$$$$want" || { echo "$$(RED)rabbit_mmu backtrace $(1) $(2) failed: no '$$$$want'$$(RESET)"; exit 1; }; \
	done; \
	out=$$$$(z88dk-ticks -m$(1) -banks -x dbgb_$(1)_$(2).map -d -script dbgb_fin.txt dbgb_$(1)_$(2).bin 2>&1); \
	for want in 'function bank2_inner returned: 33' '(_bank1_outer+' 'function bank1_outer returned: 43' '(_main+'; do \
		echo "$$$$out" | grep -qF -- "$$$$want" || { echo "$$(RED)rabbit_mmu finish $(1) $(2) failed: no '$$$$want'$$(RESET)"; exit 1; }; \
	done; \
	echo "$$(GREEN)rabbit_mmu banked backtrace $(1) $(2) passed$$(RESET)"
endef

$(foreach cpu,r2ka r4k,$(foreach comp,$(BANK_COMPILERS),$(eval $(call dbgb_test,$(cpu),$(comp)))))

dbgbtests: $(DBGB_TESTS)

# The same backtrace on the ZX Next, with the real zxn_banked_call.asm. Bank N
# is the 8K page N (and N+1) in MMU slots 6 and 7, so the stack has to stay
# below 0xC000 (REGISTER_SP). dbgz_banks.asm comes first because it places
# the bank sections.
ZXN_BANKED_CALL = ../../../libsrc/target/zxn/far/zxn_banked_call.asm

define dbgz_test
DBGZ_TESTS += rundbgz_$(1)
rundbgz_$(1): dbgz_main.c dbgz_b1.c dbgz_b2.c dbgz_banks.asm dbgz_bt.txt dbgz_fin.txt
	@zcc +test -clib=zxn -compiler=$(1) -debug -pragma-define:REGISTER_SP=0xBF00 dbgz_banks.asm dbgz_main.c dbgz_b1.c dbgz_b2.c $$(ZXN_BANKED_CALL) -Ca-D__CLASSIC -o dbgz_$(1).bin -m
	@out=$$$$(z88dk-ticks -mz80n -banks -x dbgz_$(1).map -d -script dbgz_bt.txt dbgz_$(1).bin 2>&1); \
	for want in 'function bank2_inner' '<int16_t>i = 11' 'function bank1_outer' '<int16_t>o = 10' 'function main' 'at dbgz_b2.c:5' 'at dbgz_b1.c:6' 'at dbgz_main.c:5' 'frame 2' '6=20 7=21'; do \
		echo "$$$$out" | grep -qF -- "$$$$want" || { echo "$$(RED)rabbit_mmu zxn backtrace $(1) failed: no '$$$$want'$$(RESET)"; exit 1; }; \
	done; \
	out=$$$$(z88dk-ticks -mz80n -banks -x dbgz_$(1).map -d -script dbgz_fin.txt dbgz_$(1).bin 2>&1); \
	for want in 'function bank2_inner returned: 33' '(_bank1_outer+' 'function bank1_outer returned: 43' '(_main+'; do \
		echo "$$$$out" | grep -qF -- "$$$$want" || { echo "$$(RED)rabbit_mmu zxn finish $(1) failed: no '$$$$want'$$(RESET)"; exit 1; }; \
	done; \
	echo "$$(GREEN)rabbit_mmu zxn banked backtrace $(1) passed$$(RESET)"
endef

$(foreach comp,$(BANK_COMPILERS),$(eval $(call dbgz_test,$(comp))))

dbgztests: $(DBGZ_TESTS)

# The far string functions and sprintf with a far %S, on far memory that
# crosses 256 byte, 4k and 64k boundaries. The generic far suite
# (test/suites/far) runs on the Rabbit as well.
FARSUITE = ../far/main.c ../far/sprintf.c ../far/strcasecmpf.c ../far/strchrf.c ../far/strcmpf.c ../far/strncatf.c
FRAMEWORK_SRC = $(wildcard ../../framework/*.c)

define farstr_test
FARSTR_TESTS += runfarstr_$(1)_$(2)
runfarstr_$(1)_$(2): farstr_main.c
	@zcc +test -compiler=$(2) -clib=$$(CRT_CLIB_$(1)) -pragma-define:CRT_RABBIT_BANKS=0 farstr_main.c -lm -o farstr_$(1)_$(2).bin
	@got=$$$$(z88dk-ticks -m$(1) farstr_$(1)_$(2).bin | head -3 | tr '\n' ' '); \
	case "$$$$got" in *"checks=45 fails=0"*) echo "$$(GREEN)rabbit_mmu far strings $(1) $(2) passed$$(RESET)";; \
	*) echo "$$(RED)rabbit_mmu far strings $(1) $(2) failed: $$$$got$$(RESET)"; exit 1;; esac
FARSTR_TESTS += runfarsuite_$(1)_$(2)
runfarsuite_$(1)_$(2): $$(FARSUITE)
	@zcc +test -compiler=$(2) -clib=$$(CRT_CLIB_$(1)) -I../../framework -DNO_LOG_RUNNING -DNO_LOG_PASSED -D__Z80 -pragma-define:CRT_RABBIT_BANKS=0 $$(FRAMEWORK_SRC) $$(FARSUITE) -lm -o farsuite_$(1)_$(2).bin
	@got=$$$$(z88dk-ticks -m$(1) -w 60 farsuite_$(1)_$(2).bin | grep -c " 0 failed"); \
	if [ "$$$$got" = "5" ]; then echo "$$(GREEN)rabbit_mmu far suite $(1) $(2) passed$$(RESET)"; \
	else echo "$$(RED)rabbit_mmu far suite $(1) $(2) failed: $$$$got of 5 groups clean$$(RESET)"; exit 1; fi
endef

$(foreach cpu,r2ka r3k r4k r6k,$(foreach comp,$(BANK_COMPILERS),$(eval $(call farstr_test,$(cpu),$(comp)))))

farstrtests: $(FARSTR_TESTS)

clean:
	rm -f *.o m4_*.out farstr_*.bin farsuite_*.bin dbgz_*.bin dbgz_*.map dbgb_*.bin dbgb_*.map dbgv_*.bin dbgv_*.map dbgv_*.out pragma_*.bin dbgl_*.bin dbgl_*.map mmu.bin mmu4k.bin mmu4k_seg.bin mmu_*.out mmu4k_*.out mmu4k_seg_*.out crt_*.bin crt12_*.bin bank_*.bin bank_*_BANK_*.bin far_*.bin far24_*.bin dbg_*.bin dbg_*.map bank_zxn.bin bank_msx.bin *.lis *.o *~ zcc_opt.def

.PHONY: all banktests fartests far24tests debugtests dbglinetests dbgvartests dbgbtests dbgztests pragmatests farstrtests bankstyletests runbank_zxn runbank_msx clean
