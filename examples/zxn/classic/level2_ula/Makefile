

FILES = stencil.c 

sprite.nex: $(FILES)
	zcc +zxn -o stencil.bin  $(FILES) -pragma-include:zpragma.inc -lndos -subtype=nex -clib=classic -create-app --generic-console



clean:
	$(RM) *.nex *.bin
