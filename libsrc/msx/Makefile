#
# Build the MSX target libraries
# Special cases are for the +svi and +msx target platforms
# other platforms will have a default emulation layer
#
# $Id: Makefile $
#


include ../Make.config


TARGET ?= test

ifeq ($(SUBTYPE),) 
SUBTYPE=$(TARGET)
OBJSUBDIR = $(TARGET)
else
OBJSUBDIR = $(SUBTYPE)
endif

# We keep only an harmless element in SUBSET, the asm files will still be built in the linking stage 
SUBSET = dithpat.o
GENOBJECTS = 
CUSTOBJECTS =  msx_blit.o msx_blit_fill_vram.o msx_blit_ram_vram.o msx_calculate_side.o \
               msx_put_sprite_16.o msx_put_sprite_8.o msx_set_sprite_16.o msx_set_sprite_8.o \
               msx_set_char.o msx_set_char_attr.o msx_set_char_color.o msx_set_char_form.o \
               msx_set_sprite_mode.o msx_vfill_v.o msx_set_mangled_mode.o 

ifeq ($(SUBSET),)
ASMFILES = $(wildcard *.asm)
else
ASMFILES = $(SUBSET)
endif

OBJECTS = $(CUSTOBJECTS) $(ASMFILES:.asm=.o)

all: dirs $(addprefix obj/$(OBJSUBDIR)/,$(OBJECTS)) 

obj/$(OBJSUBDIR)/%.o: %.c
	zcc +$(TARGET) $(CFLAGS) -o $@  $^

obj/$(OBJSUBDIR)/%.o: %.asm
	@$(ASSEMBLER) -DFOR$(TARGET) -I..  $^
	@mv $(^:.asm=.o) $@

dirs:
	@mkdir -p obj/$(OBJSUBDIR)

clean:
	$(RM) -fr obj
	$(RM) -f */*.o
