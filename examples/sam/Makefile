PROGS = hello keyget dstar enigma gfx smile cube mandel

all: $(PROGS)


hello:	hello.c
	zcc +sam -vn hello.c -o hello

keyget: keyget.c
	zcc +sam -vn keyget.c -o keyget

gfx:	gfx.c
	zcc +sam -vn gfx.c -o gfx

graygfx:
	zcc +sam -vn graygfx.c -o graygfx

smile:  smile.c
	zcc +sam -vn smile.c -o smile

cube:	cube.c
	zcc +sam -vn cube.c -o cube -lm

dstar:  dstar.c dstar.h
	zcc +sam -vn dstar.c -o dstar

enigma: enigma.c
	zcc +sam -vn enigma.c -o enigma

mandel: mandel.c
	zcc +sam -vn mandel.c -o mandel -lm

rpn:
	zcc +zx -vn rpn.c -o rpn.bin -lndos

adv:
	zcc +zx -vn adv_a.c -o adv_a.bin -lndos

ansitest:
	zcc +zxansi -vn ansitest.c -o ansitest.bin -lndos


clean:
	rm -f *.i *.asm *.op* *.o *~ zcc_opt.def $(PROGS)
