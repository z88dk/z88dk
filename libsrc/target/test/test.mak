TEST_SOURCES := $(filter-out target/test/far/%,$(call rwildcard,target/test,*.asm))
TEST_ASM_SOURCES_z80 := $(TEST_SOURCES) $(call rwildcard,target/test/far,*.asm)
TEST_ASM_SOURCES_z180 := $(TEST_SOURCES)
TEST_ASM_SOURCES_ez80_z80 := $(TEST_SOURCES)
TEST_ASM_SOURCES_r2ka := $(TEST_SOURCES)
TEST_ASM_SOURCES_r4k := $(TEST_SOURCES)
TEST_ASM_SOURCES_8080 := $(TEST_SOURCES)
TEST_ASM_SOURCES_8085 := $(TEST_SOURCES)
TEST_ASM_SOURCES_vm1 := $(TEST_SOURCES)
TEST_ASM_SOURCES_gbz80 := $(TEST_SOURCES)
TEST_ASM_SOURCES_kc160 := $(TEST_SOURCES)
TEST_VARIANTS := z80 z180 ez80_z80 r2ka r4k 8080 8085 vm1 gbz80 kc160
TEST_TARGETS := $(foreach variant,$(TEST_VARIANTS),target/test/obj/target-test-$(variant))

$(eval $(call gfx_stamp_args,test,TARGET=test))
CLEAN += target-test-clean
TOCREATE += $(call check_target,test,test_clib.lib testz180_clib.lib testez80_z80_clib.lib test8080_clib.lib test8085_clib.lib testvm1_clib.lib testrcm_clib.lib testrcm4k_clib.lib testkc160_clib.lib testgbz80_clib.lib)
define test_asm
target/test/obj/target-test-$(1): $(TEST_ASM_SOURCES_$(1))
	$$(Q)mkdir -p target/test/obj/$(1)
	$$(Q)$$(ASSEMBLER) -d -O=target/test/obj/$(1)/x -m4=-I$$(Z88DK_LIB)/../src/m4 -m4=-I$$(Z88DK_LIBSRC)/target/test -I$$(Z88DK_LIB) -I$$(Z88DK_LIB)/target/test/def -Itarget/test -Itarget/test/obj/$(1) -I$$(Z88DK_LIBSRC)/classic $$(TEST_ASMFLAGS_$(1)) -DSTANDARDESCAPECHARS -D__CLASSIC -DFORtest $$(TEST_ASM_SOURCES_$(1))
	$$(Q)touch $$@
endef
TEST_ASMFLAGS_z80 := -mz80
TEST_ASMFLAGS_z180 := -mz180
TEST_ASMFLAGS_ez80_z80 := -mez80_z80
TEST_ASMFLAGS_r2ka := -mr2ka
TEST_ASMFLAGS_r4k := -mr4k
TEST_ASMFLAGS_8080 := -m8080
TEST_ASMFLAGS_8085 := -m8085
TEST_ASMFLAGS_vm1 := -mvm1
TEST_ASMFLAGS_gbz80 := -mgbz80
TEST_ASMFLAGS_kc160 := -mkc160
$(foreach variant,$(TEST_VARIANTS),$(eval $(call test_asm,$(variant))))

test_clib.lib: $(TARGET_CLIB_DEPS) $(TEST_TARGETS) classic/gfx/obj/.stamp-test
	@echo ''
	@echo '--- Building Test System Library ---'
	@echo ''
	TARGET=test TYPE=z80 $(LIBLINKER2) -mz80 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/test_clib @$(TARGET_DIRECTORY)/test/test.lst

testz180_clib.lib: $(TARGET_CLIB_DEPS) $(TEST_TARGETS)
	@echo ''
	@echo '--- Building Test System Library (z180) ---'
	@echo ''
	TARGET=test TYPE=z180 $(LIBLINKER2) -mz180 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testz180_clib @$(TARGET_DIRECTORY)/test/test_nofar.lst

testez80_z80_clib.lib: $(TARGET_CLIB_DEPS) $(TEST_TARGETS)
	@echo ''
	@echo '--- Building Test System Library (ez80_z80) ---'
	@echo ''
	TARGET=test TYPE=ez80_z80 $(LIBLINKER2) -mez80_z80 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testez80_z80_clib @$(TARGET_DIRECTORY)/test/test_nofar.lst

testrcm_clib.lib: $(TARGET_CLIB_DEPS) $(TEST_TARGETS)
	@echo ''
	@echo '--- Building Test System Library (Rabbit) ---'
	@echo ''
	TARGET=test TYPE=r2ka $(LIBLINKER2) -mr2ka -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testrcm_clib @$(TARGET_DIRECTORY)/test/test_nofar.lst

testrcm4k_clib.lib: $(TARGET_CLIB_DEPS) $(TEST_TARGETS)
	@echo ''
	@echo '--- Building Test System Library (Rabbit4k) ---'
	@echo ''
	TARGET=test TYPE=r4k $(LIBLINKER2) -mr4k -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testrcm4k_clib @$(TARGET_DIRECTORY)/test/test_nofar.lst

test8080_clib.lib: $(TARGET_CLIB_DEPS) $(TEST_TARGETS)
	@echo ''
	@echo '--- Building Test System Library (8080) ---'
	@echo ''
	TARGET=test TYPE=8080 $(LIBLINKER2) -m8080 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/test8080_clib @$(TARGET_DIRECTORY)/test/test8080.lst

test8085_clib.lib: $(TARGET_CLIB_DEPS) $(TEST_TARGETS)
	@echo ''
	@echo '--- Building Test System Library (8085) ---'
	@echo ''
	TARGET=test TYPE=8085 $(LIBLINKER2) -m8085 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/test8085_clib @$(TARGET_DIRECTORY)/test/test8085.lst

testvm1_clib.lib: $(TARGET_CLIB_DEPS) $(TEST_TARGETS)
	@echo ''
	@echo '--- Building Test System Library (vm1) ---'
	@echo ''
	TARGET=test TYPE=vm1 $(LIBLINKER2) -mvm1 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testvm1_clib @$(TARGET_DIRECTORY)/test/testvm1.lst

testgbz80_clib.lib: $(TARGET_CLIB_DEPS) $(TEST_TARGETS)
	@echo ''
	@echo '--- Building Test System Library (gbz80) ---'
	@echo ''
	TARGET=test TYPE=gbz80 $(LIBLINKER2) -mgbz80 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testgbz80_clib @$(TARGET_DIRECTORY)/test/testgbz80.lst

testkc160_clib.lib: $(TARGET_CLIB_DEPS) $(TEST_TARGETS)
	@echo ''
	@echo '--- Building Test System Library (kc160) ---'
	@echo ''
	TARGET=test TYPE=kc160 $(LIBLINKER2) -mkc160 -DFORtest -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/testkc160_clib @$(TARGET_DIRECTORY)/test/test_nofar.lst

target-test: $(TEST_TARGETS)

.PHONY: target-test target-test-clean

target-test-clean:
	$(RM) -fr target/test/obj
