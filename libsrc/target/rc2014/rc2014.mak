$(eval $(call gfx_stamp_portable,rc2014,rc2014))
TOCREATE += $(call check_target,rc2014,rc2014-8085_clib.lib)
rc2014-8085_clib.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-rc2014
	@echo ''
	@echo '--- Building RC2014-8085 Library ---'
	@echo ''
	m4 -DCFG_ASM_DEF target/rc2014/config_8085.m4 > target/rc2014/config_rc2014-8085_private.inc
	m4 -DCFG_ASM_PUB target/rc2014/config_8085.m4 > target/rc2014/config_rc2014-8085_public.inc
	m4 -DCFG_C_DEF target/rc2014/config_8085.m4 > target/rc2014/config_rc2014-8085.h
	$(RM) target/rc2014/driver/ide/asm/*.o
	$(RM) target/rc2014/driver/diskio/8085/*.o
	TARGET=rc2014 TYPE=8085 $(LIBLINKER) -m8085 -DFORrc2014 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/rc2014-8085_clib @$(TARGET_DIRECTORY)/rc2014/rc2014-8085.lst
