TARGETS = sin.ihx physics.ihx box.ihx turtle.lib turtle_example.ihx mandel.ihx

CCFLAGS_850 = +g800 -lm -create-app -clib=g850
CCFLAGS_850b = +g800 -lm -create-app -clib=g850b
CC = zcc
EMULATOR = g800

all: $(TARGETS)

turtle_example.ihx: turtle_example.c turtle.lib
	$(CC) $(CCFLAGS_850b) -lturtle -o$*.ihx $<

turtle.lib: turtle.c
	$(CC) +g800 -lm -x -oturtle $<

mandel.ihx: mandel.c
	$(CC) $(CCFLAGS_850) -lturtle -o$*.ihx $<

.SUFFIXES: .c .ihx
.c.ihx:
	$(CC) $(CCFLAGS_850b) -o$*.ihx $<

.PHONY: clean
clean:
	$(RM) $(TARGETS) *.o *.def *.bin *.rom *.lst *.lib g800user.txt
