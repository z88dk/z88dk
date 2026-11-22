# For more examples see: examples/console/

# Note: just building hello worlds


all: world.82p world.83p world.8xk world.8xp world.85s world.86p

clean:
	$(RM) build/*.8xp build/*.bin build/*.8xk build/*.82p build/*.83p build/*.85s build/*.86p

bclean: # Remove bins
	$(RM) build/*.bin

world.82p: world.c # Build as a program for the ti82
	zcc +ti82 -o build/world.bin -create-app world.c

world.83p: world.c # Build as a program for the ti83
	zcc +ti83 -o build/world.bin -create-app world.c

world.8xk: world.c # Build as a flash app for the ti83p / ti84p
	zcc +ti83p -o build/world.bin world.c -create-app -subtype=app_one_page
	mv build/world.bin.8xk build/world.8xk

world.8xp: world.c  # Build as a program for the ti83p / ti84p
	zcc +ti83p -o build/world.bin -create-app world.c -subtype=asm

world.85s: world.c  # Build as a program for the ti85
	zcc +ti85 -o build/world.bin -create-app world.c

world.86p: world.c  # Build as a program for the ti86
	zcc +ti86 -o build/world.bin -create-app world.c
