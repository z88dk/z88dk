

all: dstar enigma rpn adv ansitest gfx


gfx:
	zcc +zx -vn gfx.c -o gfx.bin -lndos

dstar:
	zcc +zx -vn dstar.c -o dstar.bin -lndos

enigma:
	zcc +zx -vn enigma.c -o enigma.bin -lndos

rpn:
	zcc +zx -vn rpn.c -o rpn.bin -lndos

adv:
	zcc +zx -vn adv_a.c -o adv_a.bin -lndos

ansitest:
	zcc +zxansi -vn ansitest.c -o ansitest.bin -lndos


clean:
	rm -f *.bin *.i *.asm *.op* *.o *~ zcc_opt.def
