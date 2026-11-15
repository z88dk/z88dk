include ../make.config

SRC = test_sdhl.c sdhl_harness.asm \
	../../../libsrc/classic/sdcard/sd_wait_data_token.asm \
	../../../libsrc/classic/sdcard/sd_wait_not_busy.asm \
	../../../libsrc/classic/sdcard/sd_read_sector_main.asm \
	../../../libsrc/classic/sdcard/sd_read_bytes.asm \
	../../../libsrc/classic/sdcard/sd_read_sector_callee.asm \
	../../../libsrc/classic/sdcard/sd_read_sectors_callee.asm \
	../../../libsrc/classic/sdcard/sd_read_sectors.asm \
	../../../libsrc/classic/sdcard/sd_write_sectors_callee.asm \
	../../../libsrc/classic/sdcard/sd_state.asm

ASMINC = -Ca-I../../../lib -Ca-I../../../libsrc/classic/sdcard

all: sdhl.bin sdhl85.bin sdhl80.bin sdhlgb.bin sdhlvm.bin

define run_cpu
	@echo "$(GREEN)" `date +%H:%M:%S` " Starting test $(RESET)"
	@$(MACHINE) -b msx $(1) $@ || { echo "$(RED)" `date +%H:%M:%S` " Test failure $(RESET)" ; exit 1; }
	@echo "$(GREEN)" `date +%H:%M:%S` " Test completed $(RESET)"
endef

sdhl.bin: $(SRC)
	$(call compile,$(ASMINC),)
	$(call run_cpu,-mz80)

sdhl85.bin: $(SRC)
	$(call compile_8085,$(ASMINC))
	$(call run_cpu,-m8085)

sdhl80.bin: $(SRC)
	$(call compile_8080,$(ASMINC))
	$(call run_cpu,-m8080)

sdhlgb.bin: $(SRC)
	$(call compile_gbz80,$(ASMINC))
	$(call run_cpu,-mgbz80)

sdhlvm.bin: $(SRC)
	$(call compile_vm1,$(ASMINC))
	$(call run_cpu,-mvm1)

clean:
	rm -f sdhl.bin sdhl85.bin sdhl80.bin sdhlgb.bin sdhlvm.bin *.map zcc_opt.def *~
