
all: embedded_clib2.lib hello.bin sine.bin loop.bin savage.bin

embedded_clib2.lib: fputc_cons.asm fgetc_cons.asm
	z80asm -d -DFORembedded -xembedded_clib2 @clib2.lst

ns16450.o: embedded_clib2.lib ns16450.h ns16450.c
	zcc +embedded -c ns16450.c 

hello.bin: embedded_clib2.lib ns16450.o hello.c
	zcc +embedded ns16450.o hello.c -o hello.bin -L. -lembedded_clib2

sine.bin: embedded_clib2.lib ns16450.o sine.c
	zcc +embedded -lm ns16450.o sine.c -o sine.bin -L. -lembedded_clib2

loop.bin: embedded_clib2.lib ns16450.o loop.c
	zcc +embedded -lm ns16450.o loop.c -o loop.bin -L. -lembedded_clib2

savage.bin: embedded_clib2.lib ns16450.o savage.c
	zcc +embedded -lm ns16450.o savage.c -o savage.bin -L. -lembedded_clib2

clean:
	$(RM) *.bin *.i *.lib *.op* *.o *~ zcc_opt.def
