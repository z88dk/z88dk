

all: dstar ansitest gfx save


save:
	zcc +zx -vn save.c -o save.bin

gfx:
	zcc +zx -vn gfx.c -o gfx.bin -lndos

dstar:
	zcc +zx -vn dstar.c -o dstar.bin -lndos

ansitest:
	zcc +zxansi -vn ansitest.c -o ansitest.bin -lndos


clean:
	$(RM) *.bin *.i *.asm *.op* *.o *~ zcc_opt.def
