$(eval $(call gfx_stamp_args,test,TARGET=test))
TOCREATE += $(call check_target,test,test_clib.lib testz180_clib.lib testez80_z80_clib.lib test8080_clib.lib test8085_clib.lib testvm1_clib.lib testrcm_clib.lib testrcm4k_clib.lib testkc160_clib.lib testgbz80_clib.lib)
test_clib.lib: $(TARGET_CLIB_DEPS) classic/gfx/obj/.stamp-test
	@echo ''
	@echo '--- Building Test System Library ---'
	@echo ''
	TARGET=test TYPE=z80 $(LIBLINKER2) -mz80 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/test_clib @$(TARGET_DIRECTORY)/test/test.lst

testz180_clib.lib: $(TARGET_CLIB_DEPS) test_clib.lib
	@echo ''
	@echo '--- Building Test System Library (z180) ---'
	@echo ''
	TARGET=test TYPE=z180 $(LIBLINKER2) -mz180 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testz180_clib @$(TARGET_DIRECTORY)/test/test.lst

testez80_z80_clib.lib: $(TARGET_CLIB_DEPS) testz180_clib.lib
	@echo ''
	@echo '--- Building Test System Library (ez80_z80) ---'
	@echo ''
	TARGET=test TYPE=ez80_z80 $(LIBLINKER2) -mez80_z80 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testez80_z80_clib @$(TARGET_DIRECTORY)/test/test.lst

testrcm_clib.lib: $(TARGET_CLIB_DEPS) testez80_z80_clib.lib
	@echo ''
	@echo '--- Building Test System Library (Rabbit) ---'
	@echo ''
	TARGET=test TYPE=r2ka $(LIBLINKER2) -mr2ka -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testrcm_clib @$(TARGET_DIRECTORY)/test/testrcm.lst

testrcm4k_clib.lib: $(TARGET_CLIB_DEPS) testrcm_clib.lib
	@echo ''
	@echo '--- Building Test System Library (Rabbit4k) ---'
	@echo ''
	TARGET=test TYPE=r4k $(LIBLINKER2) -mr4k -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testrcm4k_clib @$(TARGET_DIRECTORY)/test/testrcm.lst

test8080_clib.lib: $(TARGET_CLIB_DEPS) testrcm4k_clib.lib
	@echo ''
	@echo '--- Building Test System Library (8080) ---'
	@echo ''
	TARGET=test TYPE=8080 $(LIBLINKER2) -m8080 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/test8080_clib @$(TARGET_DIRECTORY)/test/test8080.lst

test8085_clib.lib: $(TARGET_CLIB_DEPS) test8080_clib.lib
	@echo ''
	@echo '--- Building Test System Library (8085) ---'
	@echo ''
	TARGET=test TYPE=8085 $(LIBLINKER2) -m8085 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/test8085_clib @$(TARGET_DIRECTORY)/test/test8085.lst

testvm1_clib.lib: $(TARGET_CLIB_DEPS) test8085_clib.lib
	@echo ''
	@echo '--- Building Test System Library (vm1) ---'
	@echo ''
	TARGET=test TYPE=vm1 $(LIBLINKER2) -mvm1 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testvm1_clib @$(TARGET_DIRECTORY)/test/testvm1.lst

testgbz80_clib.lib: $(TARGET_CLIB_DEPS) testvm1_clib.lib
	@echo ''
	@echo '--- Building Test System Library (gbz80) ---'
	@echo ''
	TARGET=test TYPE=gbz80 $(LIBLINKER2) -mgbz80 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testgbz80_clib @$(TARGET_DIRECTORY)/test/testgbz80.lst

testkc160_clib.lib: $(TARGET_CLIB_DEPS) testgbz80_clib.lib
	@echo ''
	@echo '--- Building Test System Library (kc160) ---'
	@echo ''
	TARGET=test TYPE=kc160 $(LIBLINKER2) -mkc160 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testkc160_clib @$(TARGET_DIRECTORY)/test/test.lst
