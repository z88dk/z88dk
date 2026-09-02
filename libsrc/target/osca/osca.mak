OSCA_SOURCES := $(shell find target/osca -type f -name '*.asm')
OSCA_CFILES := $(shell find target/osca -type f -name '*.c')
OSCA_OFILES := $(patsubst target/osca/%,target/osca/obj/osca/%,$(OSCA_CFILES:.c=.o))

OSCA_TARGETS := target/osca/obj/target-osca-osca $(OSCA_OFILES) classic/games/obj/.stamp-osca classic/gfx/obj/.stamp-osca

flosdos.lib:
	$(MAKE) -C target/osca/fcntl/flos all

flosxdos.lib:
	$(MAKE) -C target/osca/fcntl/flosmulti all

CLEAN += target-osca-clean
osca_clib.lib: $(TARGET_CLIB_DEPS) $(SDCARD_OBJS) $(OSCA_TARGETS)
	@echo ''
	@echo '--- Building Old School Computer Architecture Library ---'
	@echo ''
	TARGET=osca TYPE=z80 $(LIBLINKER) -DFORosca -DSTANDARDESCAPECHARS -DSDHC_SUPPORT -x$(OUTPUT_DIRECTORY)/osca_clib.lib @$(TARGET_DIRECTORY)/osca/osca.lst

TOCREATE += $(call check_target,osca,osca_clib.lib flosdos.lib flosxdos.lib)

$(eval $(call gfx_stamp_args,osca,TARGET=osca FLAVOUR=wide))

target-osca: $(OSCA_TARGETS)

.PHONY: target-osca target-osca-clean

$(eval $(call buildtargetasm,target/osca,z80,osca,-mz80,$(OSCA_SOURCES),$(OSCA_SOURCES)))
$(eval $(call buildtargetc,target/osca,osca))

target-osca-clean:
	$(RM) -fr target/osca/obj
