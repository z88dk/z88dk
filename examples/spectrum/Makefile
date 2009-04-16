

all: dstar ansitest gfx save ccoswave c3d cmandel csprite zxbasic zxcurrah


save:
	zcc +zx -vn save.c -o save.bin -create-app 

gfx:
	zcc +zx -vn gfx.c -o gfx.bin -lndos -create-app

dstar:
	zcc +zx -vn dstar.c -o dstar.bin -create-app -lndos

ansitest:
	zcc +zxansi -vn ansitest.c -o ansitest.bin -create-app -lndos

ccoswave:
	zcc +zx -vn ccoswave.c -lndos -lm -create-app -occoswave.bin

c3d:
	zcc +zx -vn c3d.c -lndos -llib3d -create-app -oc3d.bin

cmandel:
	zcc +zx -vn ccoswave.c -lndos -lm -create-app -ocmandel.bin

csprite:
	zcc +zx -vn csprite.c -lndos -create-app -ocsprite.bin

zxbasic:
	zcc +zx -vn zxbasic.c -lndos -create-app -ozxbasic.bin

zxcurrah:
	zcc +zx -vn zxbasic.c -lndos -create-app -ozxcurrah.bin

clean:
	$(RM) *.bin *.i *.asm *.tap *.op* *.o *~ zcc_opt.def
