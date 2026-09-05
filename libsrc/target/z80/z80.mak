Z80_SOURCES := $(call rwildcard,target/z80,*.asm)
Z80_VARIANTS := z80 ixiy 8080 8085 vm1 r2ka r4k kc160
Z80_TARGETS := $(foreach variant,$(Z80_VARIANTS),target/z80/obj/target-z80-$(variant))
Z80_STDIO_z80 := $(addprefix classic/stdio/obj/z80/,$(STDIO_OBJECTS))
Z80_STDIO_ixiy := $(addprefix classic/stdio/obj/ixiy/,$(STDIO_OBJECTS))
Z80_STDIO_8080 := $(addprefix classic/stdio/obj/8080/,$(STDIO_8080_OBJECTS))
Z80_STDIO_8085 := $(addprefix classic/stdio/obj/8085/,$(STDIO_8085_OBJECTS))
Z80_STDIO_vm1 := $(addprefix classic/stdio/obj/vm1/,$(STDIO_8085_OBJECTS))
Z80_STDIO_r2ka := $(addprefix classic/stdio/obj/r2ka/,$(STDIO_OBJECTS))
Z80_STDIO_r4k := $(addprefix classic/stdio/obj/r4k/,$(STDIO_OBJECTS))
Z80_STDIO_kc160 := $(addprefix classic/stdio/obj/kc160/,$(STDIO_OBJECTS))

$(eval $(call gfx_stamp_args,z80,TARGET=z80))
CLEAN += target-z80-clean
TOCREATE += $(call check_target,z80,z80_clib.lib ixiy_clib.lib 8080_clib.lib 8085_clib.lib vm1_clib.lib r2ka_clib.lib r4k_clib.lib kc160_clib.lib)
define z80_asm
target/z80/obj/target-z80-$(1): $(Z80_SOURCES)
	$$(Q)mkdir -p target/z80/obj/$(1)
	$$(Q)$$(ASSEMBLER) -d -O=target/z80/obj/$(1)/x -m4=-I$$(Z88DK_LIB)/../src/m4 -m4=-I$$(Z88DK_LIBSRC)/target/z80 -I$$(Z88DK_LIB) -I$$(Z88DK_LIB)/target/z80/def -Itarget/z80 -Itarget/z80/obj/$(1) -I$$(Z88DK_LIBSRC)/classic $$(Z80_ASMFLAGS_$(1)) -DSTANDARDESCAPECHARS -D__CLASSIC -DFORz80 $$(Z80_SOURCES)
	$$(Q)touch $$@
endef
Z80_ASMFLAGS_z80 := -mz80
Z80_ASMFLAGS_ixiy := -mz80 -IXIY
Z80_ASMFLAGS_8080 := -m8080
Z80_ASMFLAGS_8085 := -m8085
Z80_ASMFLAGS_vm1 := -mvm1
Z80_ASMFLAGS_r2ka := -mr2ka
Z80_ASMFLAGS_r4k := -mr4k
Z80_ASMFLAGS_kc160 := -mkc160
$(foreach variant,$(Z80_VARIANTS),$(eval $(call z80_asm,$(variant))))

z80_clib.lib: $(TARGET_CLIB_DEPS) $(Z80_TARGETS) $(Z80_STDIO_z80) classic/gfx/obj/.stamp-z80
	@echo ''
	@echo '--- Building +z80 Library ---'
	@echo ''
	TARGET=z80 TYPE=z80 $(LIBLINKER2) -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/z80_clib @$(TARGET_DIRECTORY)/z80/z80.lst

ixiy_clib.lib: $(TARGET_CLIB_DEPS) $(Z80_TARGETS) $(Z80_STDIO_ixiy)
	@echo ''
	@echo '--- Building +z80 (ixiy) Library ---'
	@echo ''
	TARGET=z80 TYPE=ixiy $(LIBLINKER2) -IXIY -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/ixiy_clib @$(TARGET_DIRECTORY)/z80/z80.lst

8080_clib.lib: $(TARGET_CLIB_DEPS) $(Z80_TARGETS) $(Z80_STDIO_8080)
	@echo ''
	@echo '--- Building +z80 (8080) Library ---'
	@echo ''
	TARGET=z80 TYPE=8080 $(LIBLINKER2) -m8080 -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/8080_clib @$(TARGET_DIRECTORY)/z80/808x.lst

8085_clib.lib: $(TARGET_CLIB_DEPS) $(Z80_TARGETS) $(Z80_STDIO_8085)
	@echo ''
	@echo '--- Building +z80 (8085) Library ---'
	@echo ''
	TARGET=z80 TYPE=8085 $(LIBLINKER2) -m8085 -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/8085_clib @$(TARGET_DIRECTORY)/z80/808x.lst

vm1_clib.lib: $(TARGET_CLIB_DEPS) $(Z80_TARGETS) $(Z80_STDIO_vm1)
	@echo ''
	@echo '--- Building +z80 (vm1) Library ---'
	@echo ''
	TARGET=z80 TYPE=vm1 $(LIBLINKER2) -mvm1 -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/vm1_clib @$(TARGET_DIRECTORY)/z80/808x.lst

r2ka_clib.lib: $(TARGET_CLIB_DEPS) $(Z80_TARGETS) $(Z80_STDIO_r2ka)
	@echo ''
	@echo '--- Building +z80 (r2ka) Library ---'
	@echo ''
	TARGET=z80 TYPE=r2ka $(LIBLINKER2) -mr2ka -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/r2ka_clib @$(TARGET_DIRECTORY)/z80/z80.lst

r4k_clib.lib: $(TARGET_CLIB_DEPS) $(Z80_TARGETS) $(Z80_STDIO_r4k)
	@echo ''
	@echo '--- Building +z80 (r4k) Library ---'
	@echo ''
	TARGET=z80 TYPE=r4k $(LIBLINKER2) -mr4k -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/r4k_clib @$(TARGET_DIRECTORY)/z80/z80.lst

kc160_clib.lib: $(TARGET_CLIB_DEPS) $(Z80_TARGETS) $(Z80_STDIO_kc160)
	@echo ''
	@echo '--- Building +z80 (kc160) Library ---'
	@echo ''
	TARGET=z80 TYPE=kc160 $(LIBLINKER2) -mkc160 -DSTANDARDESCAPECHARS -DFORz80 -x$(OUTPUT_DIRECTORY)/kc160_clib @$(TARGET_DIRECTORY)/z80/z80.lst

fastmath.lib: kc160_clib.lib
	@echo ''
	@echo '--- Building fast integer maths library ---'
	@echo ''
	$(MAKE) -C math/integer/fastmath

target-z80: $(Z80_TARGETS)

.PHONY: target-z80 target-z80-clean

target-z80-clean:
	$(RM) -fr target/z80/obj
