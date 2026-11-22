ACE_SOURCES := $(call rwildcard,target/ace,*.asm)
ACE_CFILES := $(wildcard target/ace/tape/*.c)
ACE_OFILES := $(patsubst target/ace/%,target/ace/obj/ace/%,$(ACE_CFILES:.c=.o))

ACE_TARGETS := target/ace/obj/target-ace-ace $(ACE_OFILES) classic/games/obj/.stamp-ace classic/gfx/obj/.stamp-ace
ACEUDG_TARGETS := target/ace/obj/target-ace-aceudg classic/gfx/obj/.stamp-ace-udg

CLEAN += target-ace-clean
TOCREATE += $(call check_target,ace,ace_clib.lib gfxace.lib gfxaceudg.lib)
$(eval $(call gfx_stamp_args,ace,TARGET=ace FLAVOUR="text narrow"))
$(eval $(call gfx_stamp_args,ace-udg,TARGET=ace SUBTYPE=aceudg FLAVOUR="gencon text6 narrow"))
$(eval $(call buildtargetasm,target/ace,z80,ace,-mz80,$(ACE_SOURCES),$(ACE_SOURCES)))
$(eval $(call buildtargetasm,target/ace,z80,aceudg,-mz80,$(ACE_SOURCES),$(ACE_SOURCES)))
$(eval $(call buildtargetc,target/ace,ace))

ace_clib.lib: $(TARGET_CLIB_DEPS) $(ACE_TARGETS)
	@echo ''
	@echo '--- Building Jupiter Ace Library ---'
	@echo ''
	TARGET=ace TYPE=z80 $(LIBLINKER) -DFORace -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/ace_clib.lib @$(TARGET_DIRECTORY)/ace/ace.lst

gfxace.lib: $(TARGET_CLIB_DEPS) ace_clib.lib $(ACE_TARGETS)
	@echo ''
	@echo '--- Building Jupiter Ace Graphics Library ---'
	@echo ''
	TARGET=ace TYPE=z80 $(LIBLINKER) -DFORace -x$(OUTPUT_DIRECTORY)/gfxace @$(TARGET_DIRECTORY)/ace/gfxace.lst

gfxaceudg.lib: $(TARGET_CLIB_DEPS) gfxace.lib $(ACEUDG_TARGETS)
	@echo ''
	@echo '--- Building Jupiter Ace UDG based Graphics Library ---'
	@echo ''
	TARGET=aceudg TYPE=z80 $(LIBLINKER) -DFORaceudg -x$(OUTPUT_DIRECTORY)/gfxaceudg @$(TARGET_DIRECTORY)/ace/gfxaceudg.lst



target-ace: $(ACE_TARGETS) $(ACEUDG_TARGETS)

.PHONY: target-ace target-ace-clean


target-ace-clean:
	$(RM) -fr target/ace/obj
