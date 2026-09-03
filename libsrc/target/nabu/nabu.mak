NABU_GLOBS := \
	"target/nabu/games/*.asm" \
	"target/nabu/hcca/*.asm" \
	"target/nabu/interrupts/*.asm" \
	"target/nabu/psg/*.asm" \
	"target/nabu/stdio/*.asm"

NABU_GLOBS_ex := \
	target/nabu/games/*.asm \
	target/nabu/hcca/*.asm \
	target/nabu/interrupts/*.asm \
	target/nabu/psg/*.asm \
	target/nabu/stdio/*.asm

NABU_CFILES := $(call rwildcard,target/nabu,*.c)
NABU_OFILES := $(patsubst target/nabu/%,target/nabu/obj/nabu/%,$(NABU_CFILES:.c=.o))

NABU_TARGETS := target/nabu/obj/target-nabu-nabu $(NABU_OFILES) classic/video/tms9918/obj/nabu classic/games/obj/.stamp-nabu classic/gfx/obj/.stamp-nabu

CLEAN += target-nabu-clean
TOCREATE += $(call check_target,nabu,nabu_clib.lib nabu_cpm.lib nabu_int.lib)
$(eval $(call gfx_stamp_args,nabu,TARGET=nabu))
$(eval $(call buildtms9918,nabu,nabu))
$(eval $(call buildtargetasm,target/nabu,z80,nabu,-mz80,$(NABU_GLOBS),$(NABU_GLOBS_ex)))
$(eval $(call buildtargetc,target/nabu,nabu))

nabu_clib.lib: $(TARGET_CLIB_DEPS) $(NABU_TARGETS)
	@echo ''
	@echo '--- Building Nabu Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=nabu
	TARGET=nabu TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORnabu -x$(OUTPUT_DIRECTORY)/nabu_clib @$(TARGET_DIRECTORY)/nabu/nabu.lst

nabu_cpm.lib: nabu_clib.lib $(NABU_TARGETS)
	@echo ''
	@echo '--- Building Nabu CP/M Library ---'
	@echo ''
	$(MAKE) -C classic/video/tms9918 TARGET=nabu
	TARGET=nabu TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORnabu -x$(OUTPUT_DIRECTORY)/nabu_cpm @$(TARGET_DIRECTORY)/nabu/nabu_cpm.lst

nabu_int.lib: nabu_clib.lib nabu_cpm.lib
	@echo ''
	@echo '--- Building Nabu Interrupt Library ---'
	@echo ''
	TARGET=nabu TYPE=z80 $(LIBLINKER) -DSTANDARDESCAPECHARS -DFORnabu -x$(OUTPUT_DIRECTORY)/nabu_int @$(TARGET_DIRECTORY)/nabu/nabu_int.lst



target-nabu: $(NABU_TARGETS)

.PHONY: target-nabu target-nabu-clean



target-nabu-clean:
	$(RM) -fr target/nabu/obj
