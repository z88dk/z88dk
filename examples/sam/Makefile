PROGS = hello.bin keyget.bin dstar.bin enigma.bin gfx.bin smile.bin cube.bin mandel.bin ansitest.bin

all: $(PROGS)


hello.bin:	hello.c
	zcc +sam -vn hello.c -o hello.bin

keyget.bin: keyget.c
	zcc +sam -vn keyget.c -o keyget.bin

gfx.bin:	gfx.c
	zcc +sam -vn gfx.c -o gfx.bin

graygfx.bin:
	zcc +sam -vn graygfx.c -o graygfx.bin

smile.bin:  smile.c
	zcc +sam -vn smile.c -o smile.bin

cube.bin:	cube.c
	zcc +sam -vn cube.c -o cube.bin -lm

dstar.bin:  dstar.c dstar.h
	zcc +sam -vn dstar.c -o dstar.bin

enigma.bin: enigma.c
	zcc +sam -vn enigma.c -o enigma.bin

mandel.bin: mandel.c
	zcc +sam -vn mandel.c -o mandel.bin -lm

rpn.bin:
	zcc +sam -vn rpn.c -o rpn.bin -lndos

adv.bin:
	zcc +sam -vn adv_a.c -o adv_a.bin -lndos

ansitest.bin:
	zcc +sam -clib=ansi -vn ansitest.c -o ansitest.bin -lndos


clean:
	$(RM) *.bin *.i *.asm *.op* *.o *~ zcc_opt.def $(PROGS) 
