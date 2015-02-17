
CFLAGS  = -Wall -fomit-frame-pointer -O2 -static
LFLAGS  = -s

CC	= gcc 	# C compiler used
LD	= gcc	# Linker used


OBJECTS = sprite.o

all:    sprite

sprite:	$(OBJECTS)
	$(LD) $(LFLAGS) -o sprite $(OBJECTS) -lz -lallegro -lallegro_primitives -lallegro_image -lallegro_font -lallegro_dialog


