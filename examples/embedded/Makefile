
all:  hello.bin sine.bin loop.bin savage.bin



hello.bin: ns16450.o hello.c
	zcc +embedded ns16450.o hello.c -o hello.bin

sine.bin: sine.c
	zcc +embedded -lm ns16450.o sine.c -o sine.bin

loop.bin: loop.c
	zcc +embedded -lm ns16450.o loop.c -o loop.bin

savage.bin: savage.c
	zcc +embedded -lm ns16450.o savage.c -o savage.bin

clean:
	rm -f *.bin *.i *.lib *.op* *.o *~ zcc_opt.def
