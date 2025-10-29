include ../../../Make.config

TARGET ?= test

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/target/zxn-libs/memory/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zxn-libs/memory/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zxn-libs/globals/z80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zxn-libs/sysvar/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zxn-libs/version/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zxn-libs/version/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/ts2068-libs/misc/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/ts2068-libs/misc/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/ts2068-libs/display/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/ts2068-libs/display/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zx-libs/graphics/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx-libs/graphics/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zx-libs/display/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx-libs/display/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zx-libs/misc/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx-libs/misc/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/newlib/target/zxn/driver/banking/zxn_banked_call.asm"

NEWLIB_TARGETS := obj/newlib-z80n

space :=
space +=

OBJECTS = $(CLASSIC_OBJECTS) 

.PHONY: dirs  $(NEWLIB_TARGETS)

all: dirs $(OBJECTS) $(NEWLIB_TARGETS)

obj/newlib-z80n:  
	@$(ASSEMBLER) -d -O=obj/z80n/x -I.. -mz80n -D__CLASSIC $(NEWLIBGLOBS)

dirs:
	@mkdir -p obj/z80n 


clean:
	$(RM) -fr obj 
