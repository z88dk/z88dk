$(eval $(call gfx_stamp_args,z80,TARGET=z80))
TOCREATE += $(call check_target,z80,z80_clib.lib ixiy_clib.lib 8080_clib.lib 8085_clib.lib vm1_clib.lib r2ka_clib.lib r4k_clib.lib kc160_clib.lib)
z80_clib.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-z80
	@echo ''
	@echo '--- Building +z80 Library ---'
	@echo ''
	TARGET=z80 TYPE=z80 $(LIBLINKER2) -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/z80_clib @$(TARGET_DIRECTORY)/z80/z80.lst

ixiy_clib.lib: $(TARGET_CLIB_DEPS) z80_clib.lib
	@echo ''
	@echo '--- Building +z80 (ixiy) Library ---'
	@echo ''
	TARGET=z80 TYPE=ixiy $(LIBLINKER2) -IXIY -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/ixiy_clib @$(TARGET_DIRECTORY)/z80/z80.lst

8080_clib.lib: $(TARGET_CLIB_DEPS) ixiy_clib.lib
	@echo ''
	@echo '--- Building +z80 (8080) Library ---'
	@echo ''
	TARGET=z80 TYPE=8080 $(LIBLINKER2) -m8080 -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/8080_clib @$(TARGET_DIRECTORY)/z80/808x.lst

8085_clib.lib: $(TARGET_CLIB_DEPS) 8080_clib.lib
	@echo ''
	@echo '--- Building +z80 (8085) Library ---'
	@echo ''
	TARGET=z80 TYPE=8085 $(LIBLINKER2) -m8085 -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/8085_clib @$(TARGET_DIRECTORY)/z80/808x.lst

vm1_clib.lib: $(TARGET_CLIB_DEPS) 8085_clib.lib
	@echo ''
	@echo '--- Building +z80 (vm1) Library ---'
	@echo ''
	TARGET=z80 TYPE=vm1 $(LIBLINKER2) -mvm1 -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/vm1_clib @$(TARGET_DIRECTORY)/z80/808x.lst

r2ka_clib.lib: $(TARGET_CLIB_DEPS) vm1_clib.lib
	@echo ''
	@echo '--- Building +z80 (r2ka) Library ---'
	@echo ''
	TARGET=z80 TYPE=r2ka $(LIBLINKER2) -mr2ka -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/r2ka_clib @$(TARGET_DIRECTORY)/z80/z80.lst

r4k_clib.lib: $(TARGET_CLIB_DEPS) r2ka_clib.lib
	@echo ''
	@echo '--- Building +z80 (r4k) Library ---'
	@echo ''
	TARGET=z80 TYPE=r4k $(LIBLINKER2) -mr4k -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/r4k_clib @$(TARGET_DIRECTORY)/z80/z80.lst

kc160_clib.lib: $(TARGET_CLIB_DEPS) r4k_clib.lib
	@echo ''
	@echo '--- Building +z80 (kc160) Library ---'
	@echo ''
	TARGET=z80 TYPE=kc160 $(LIBLINKER2) -mkc160 -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/kc160_clib @$(TARGET_DIRECTORY)/z80/z80.lst

fastmath.lib: kc160_clib.lib
	@echo ''
	@echo '--- Building fast integer maths library ---'
	@echo ''
	$(MAKE) -C math/integer/fastmath
