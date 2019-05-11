#

include ../../Make.config

vpath %.c ../../_DEVELOPMENT/math/float/math32/c
vpath %.c ../cimpl

CFILES  = $(notdir $(wildcard ../../_DEVELOPMENT/math/float/math32/c/*.c)) atof.c ftoa.c ftoe.c
OBJECTS = $(CFILES:.c=.o)

CFLAGS += -fp-mode=ieee -I../../_DEVELOPMENT/math/float/math32/c/

all: dirs $(OUTPUT_DIRECTORY)/math32.lib $(OUTPUT_DIRECTORY)/math32_zxn.lib $(OUTPUT_DIRECTORY)/math32_z180.lib


$(OUTPUT_DIRECTORY)/math32.lib: $(addprefix obj/z80/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -O=obj/z80/x/x -I.. -mz80 -D__CLASSIC @newlibfiles_z80.lst
	TYPE=z80 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math32 @math32.lst

$(OUTPUT_DIRECTORY)/math32_zxn.lib: $(addprefix obj/z80-zxn/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -O=obj/z80-zxn/x/x -I.. -mz80-zxn -D__CLASSIC @newlibfiles_zxn.lst
	TYPE=z80-zxn $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math32_zxn @math32.lst

$(OUTPUT_DIRECTORY)/math32_z180.lib: $(addprefix obj/z180/, $(OBJECTS))
	$(Q)$(ASSEMBLER) -d -O=obj/z180/x/x -I.. -mz180 -D__CLASSIC @newlibfiles_z180.lst
	TYPE=z180 $(LIBLINKER) -x$(OUTPUT_DIRECTORY)/math32_z180 @math32.lst

dirs:
	@mkdir -p obj/z80/c obj/z180/c obj/z80-zxn/c

clean:
	$(RM) *.o* *.sym *.map *.err zcc_opt.def *.i *.opt
	$(RM) -fr obj

