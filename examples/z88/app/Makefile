


all: info rpn.63 useless.63 wc.63 viewer.63 dstar.63

info:
	@echo Building Application examples..

rpn.63: rpn.c
	zcc +z88 -subtype=app -vn -create-app rpn.c -o rpn.bin

useless.63: useless.c
	zcc +z88 -subtype=app -vn -create-app useless.c -o useless.bin

wc.63: wc.c
	zcc +z88 -subtype=app -vn -create-app wc.c -o wc.bin

viewer.63: viewer.c
	zcc +z88 -subtype=app -vn -create-app viewer.c -o viewer.bin

dstar.63: dstar.c dstar.h
	zcc +z88 -subtype=app -vn -create-app dstar.c -o dstar.bin

clean:
	$(RM) rpn.bin useless.bin wc.bin view.bin dstar.bin
	$(RM) *.bin *.reloc
	$(RM) zcc_opt.def *~ *.op* *.o *i *.asm *.63
