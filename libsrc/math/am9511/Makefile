#

include ../../Make.config

vpath %.c ../../_DEVELOPMENT/math/float/am9511/c
vpath %.c ../cimpl


CFILES  = $(notdir $(wildcard ../../_DEVELOPMENT/math/float/am9511/c/*.c)) atof.c ftoa.c ftoe.c
CFILES  = atof.c ftoa.c ftoe.c
OBJECTS = $(CFILES:.c=.o)

CFLAGS += -fp-mode=ieee

all: dirs $(OUTPUT_DIRECTORY)/am9511.lib $(OUTPUT_DIRECTORY)/am9511_ixiy.lib $(OUTPUT_DIRECTORY)/am9511_8085.lib

$(OUTPUT_DIRECTORY)/am9511.lib: $(addprefix obj/z80/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/z80/x/x  -I.. -mz80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/am9511 @am9511.lst

$(OUTPUT_DIRECTORY)/am9511_ixiy.lib: $(addprefix obj/ixiy/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/ixiy/x/x -I.. -IXIY -mz80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=ixiy $(LIBLINKER) -IXIY -x$(OUTPUT_DIRECTORY)/am9511_ixiy @am9511.lst

$(OUTPUT_DIRECTORY)/am9511_8085.lib: $(addprefix obj/8085/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -I$(Z88DK_LIB) -O=obj/8085/x/x -I.. -m8085 -D__CLASSIC @newlibfiles_8085.lst
	TYPE=8085 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/am9511_8085 @am9511.lst

dirs:
	@mkdir -p obj/z80/c obj/ixiy/c  obj/8085/c

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt config_private.inc
	$(RM) -fr obj

