

FILES = main.c graphics.asm.m4

sprite.nex: $(FILES)
	zcc +zxn -o sprite.bin  $(FILES) -pragma-include:zpragma.inc -lndos -subtype=nex -clib=classic -create-app



clean:
	$(RM) *.nex
