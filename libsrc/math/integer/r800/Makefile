include ../../../Make.config

LIBSRC := ../../..

NEWLIBGLOBS_ex := $(Z88DK_LIBSRC)/math/integer/r800/*.asm

all: $(OUTPUT_DIRECTORY)/r800_opt.lib

obj/newlib-z80: $(NEWLIBGLOBS_ex)
	$(Q)$(ASSEMBLER) -d -O=obj/z80/x/1/2/3 -I.. -mz80 -D__CLASSIC "$(LIBSRC)/math/integer/r800/*.asm"
	@touch $@

$(OUTPUT_DIRECTORY)/r800_opt.lib: r800_opt.lst obj/newlib-z80
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/r800_opt.lib @r800_opt.lst

clean:
	$(RM) -fr obj
