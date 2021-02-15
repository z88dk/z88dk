
include ../../../../Make.config

ASM = $(wildcard *.asm)

all: $(OUTPUT_DIRECTORY)/msxdos2.lib


$(OUTPUT_DIRECTORY)/msxdos2.lib: $(ASM)
	@$(ASSEMBLER) -I$(Z88DK_LIB) -x$(OUTPUT_DIRECTORY)/msxdos2.lib $(ASM)

clean:
	$(RM) -f *.o
	#$(RM) $(OUTPUT_DIRECTORY)/msxdos2.lib
