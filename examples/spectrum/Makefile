

all: dstar enigma rpn adv ansitest gfx


gfx:
	zcc +zx -vn gfx.c -o gfx.bin

dstar:
	zcc +zx -vn dstar.c -o dstar.bin

enigma:
	zcc +zx -vn enigma.c -o enigma.bin

rpn:
	zcc +zx -vn rpn.c -o rpn.bin

adv:
	zcc +zx -vn adv_a.c -o adv_a.bin

ansitest:
	zcc +zxansi -vn ansitest.c -o ansitest.bin


clean:
	rm -f *.bin *.i *.asm *.op* *.o *~ zcc_opt.def
