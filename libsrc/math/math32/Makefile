#

include ../../Make.config

vpath %.c ../../_DEVELOPMENT/math/float/math32/c
vpath %.c ../cimpl


CFILES  = $(notdir $(wildcard ../../_DEVELOPMENT/math/float/math32/c/*.c)) atof.c ftoa.c ftoe.c
CFILES  = atof.c ftoa.c ftoe.c ftoa_fudgeit.c
OBJECTS = $(CFILES:.c=.o)

CFLAGS += -fp-mode=ieee 

all: dirs $(OUTPUT_DIRECTORY)/math32.lib $(OUTPUT_DIRECTORY)/math32_ixiy.lib $(OUTPUT_DIRECTORY)/math32_zxn.lib $(OUTPUT_DIRECTORY)/math32_z180.lib


$(OUTPUT_DIRECTORY)/math32.lib: $(addprefix obj/z80/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z80/x/x -I.. -mz80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math32 @math32.lst

$(OUTPUT_DIRECTORY)/math32_ixiy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z80/x/x -I.. --IXIY -mz80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=z80 $(LIBLINKER) --IXIY -x$(OUTPUT_DIRECTORY)/math32_ixiy @math32.lst

$(OUTPUT_DIRECTORY)/math32_zxn.lib: $(addprefix obj/z80-zxn/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z80-zxn/x/x -I.. -mz80-zxn -D__CLASSIC @newlibfiles_zxn.lst
	TYPE=z80-zxn $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math32_zxn @math32.lst

$(OUTPUT_DIRECTORY)/math32_z180.lib: $(addprefix obj/z180/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z180/x/x -I.. -mz180 -D__CLASSIC @newlibfiles_z180.lst
	TYPE=z180 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math32_z180 @math32.lst

dirs:
	@mkdir -p obj/z80/c obj/z180/c obj/z80-zxn/c obj/ixiy/c

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

