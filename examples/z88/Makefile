


all: info cube cubez88 dstar enigma rpn sorter gfx adv_a

info:
	@echo Building examples..

adv_a:
	zcc -vn adv_a.c -o adv_a.bas

gfx:
	zcc -vn -lgfx gfx.c -o gfx.bas

cube:
	zcc -vn -lm -lgfx cube.c -o cube.bas

cubez88:
	zcc -vn -lmz -lgfx cube.c -o cubez88.bas

enigma:
	zcc -vn enigma.c -o enigma.bas

rpn:
	zcc -vn rpn.c -o rpn.bas

sorter:
	zcc -vn sorter.c -o sorter.bas

dstar:
	zcc -vn -lgfx dstar.c -o dstar.bas

clean:
	rm -f cube.bas cubez88.bas enigma.bas rpn.bas sorter.bas
	rm -f dstar.bas sorter.bas zcc_opt.def *~ *.op* *.o *i *.asm
	rm -f gfx.bas a.* adv_a.bas
