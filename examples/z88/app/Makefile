


all: info rpn useless wc viewer dstar

info:
	@echo Building Application examples..

rpn:
	zcc +z88 -subtype=app -vn -create-app rpn.c -o rpn.bin

useless:
	zcc +z88 -subtype=app -vn -create-app useless.c -o useless.bin

wc:
	zcc +z88 -subtype=app -vn -create-app wc.c -lz88 -o wc.bin

viewer:
	zcc +z88 -subtype=app -vn -create-app viewer.c -lz88 -o viewer.bin

dstar:
	zcc +z88 -subtype=app -vn -create-app dstar.c -lgfxapp -o dstar.bin

clean:
	$(RM) rpn.bin useless.bin wc.bin view.bin dstar.bin
	$(RM) zcc_opt.def *~ *.op* *.o *i *.asm *.63
