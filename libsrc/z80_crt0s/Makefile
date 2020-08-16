#
# Wahey, a messed up makefile for building libraries!
#

include ../Make.config

all: dirs $(OUTPUT_DIRECTORY)/z80_crt0.lib $(OUTPUT_DIRECTORY)/rcmx000_crt0.lib $(OUTPUT_DIRECTORY)/z80iy_crt0.lib $(OUTPUT_DIRECTORY)/z180_crt0.lib $(OUTPUT_DIRECTORY)/ez80_crt0.lib $(OUTPUT_DIRECTORY)/8080_crt0.lib $(OUTPUT_DIRECTORY)/gbz80_crt0.lib $(OUTPUT_DIRECTORY)/z80n_crt0.lib $(OUTPUT_DIRECTORY)/8085_crt0.lib


$(OUTPUT_DIRECTORY)/z80_crt0.lib:
	$(LIBLINKER) -Oobj/z80/z80 -I.. -x$@ @crt0.lst

$(OUTPUT_DIRECTORY)/z80n_crt0.lib:
	$(LIBLINKER) -Oobj/z80n/z80n -I.. -mz80n -x$@ @crt0_z80n.lst

$(OUTPUT_DIRECTORY)/8080_crt0.lib:
	$(LIBLINKER) -Oobj/8080/8080 -I.. -x$@ -DCPU_8080 -m8080 @crt0_8080.lst

$(OUTPUT_DIRECTORY)/8085_crt0.lib:
	$(LIBLINKER) -Oobj/8085/8085 -I.. -x$@ -DCPU_8085 -m8085 @crt0_8080.lst

$(OUTPUT_DIRECTORY)/gbz80_crt0.lib:
	$(LIBLINKER) -Oobj/gbz80/gbz80 -I.. -x$@ -DCPU_GBZ80 -mgbz80 @crt0_gbz80.lst

$(OUTPUT_DIRECTORY)/z180_crt0.lib:
	$(LIBLINKER) -Oobj/z180/z180 -I.. -x$@ -mz180 @crt0_z180.lst

$(OUTPUT_DIRECTORY)/ez80_crt0.lib:
	$(LIBLINKER) -Oobj/ez80/ez80 -I.. -x$@ -mz180 -DEZ80 @crt0_ez80.lst

$(OUTPUT_DIRECTORY)/rcmx000_crt0.lib:
	$(LIBLINKER) -Oobj/r2k/r2k -I.. -mr2k -x$@ @rcm.lst

# this one uses iy in place of ix
$(OUTPUT_DIRECTORY)/z80iy_crt0.lib:
	$(LIBLINKER) -Oobj/ixiy/ixiy -I.. -IXIY -D__SDCC_IX -x$@ @crt0.lst


dirs:
	@mkdir -p obj/z80 obj/ixiy obj/8080 obj/8085 obj/r2k obj/gbz80 obj/z180 obj/ez80 obj/z180 obj/z80n

clean:
	@$(RM) -r obj

