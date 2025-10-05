include ../../../Make.config

TARGET ?= test

NEWLIBGLOBS := "$(NEWLIB_DIRECTORY)/target/zxn/memory/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zxn/memory/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zxn/globals/z80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zxn/sysvar/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zxn/version/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zxn/version/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/ts2068/misc/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/ts2068/misc/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/ts2068/display/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/ts2068/display/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zx/graphics/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx/graphics/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zx/display/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx/display/c/sccz80/*.asm" \
	"$(NEWLIB_DIRECTORY)/target/zx/misc/z80/*.asm" "$(NEWLIB_DIRECTORY)/target/zx/misc/c/sccz80/*.asm" \
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
