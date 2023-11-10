# For more examples see: examples/console/

# Note: just building hello worlds

CFLAGS += -v


all: world82.82p world83.83p world83.8xk world83.8xp world85.85s world86.86p

clean:
	$(RM) build/*.8xp build/*.bin build/*.8xk build/*.82p build/*.83p build/*.85s build/*.86p

bclean: # Remove bins
	$(RM) build/*.bin

world82.82p: world.c # Build as a program for the ti82
	zcc +ti82 $(CFLAGS) -o build/world82.bin -create-app world.c

world83.83p: world.c # Build as a program for the ti83
	zcc +ti83 $(CFLAGS) -o build/world83.bin -create-app world.c

world83.8xk: world.c # Build as a flash app for the ti83p / ti84p
	zcc +ti83p $(CFLAGS) -o build/world.bin world.c -create-app -subtype=app_one_page
	mv build/world.bin.8xk build/world83.8xk

world83.8xp: world.c  # Build as a program for the ti83p / ti84p
	zcc +ti83p $(CFLAGS) -o build/world83.bin -create-app world.c -subtype=asm

world85.85s: world.c  # Build as a program for the ti85
	zcc +ti85 $(CFLAGS) -o build/world85.bin -create-app world.c

world86.86p: world.c  # Build as a program for the ti86
	zcc +ti86 $(CFLAGS) -o build/world86.bin -create-app world.c
