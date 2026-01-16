
APPMAKE = z88dk-appmake
COMPILER = -compiler=sccz80


all: demo.tap




demo.tap: bifrost2.tap bifrost2demo.tap
	cat loader.tap $^ > demo.tap


bifrost2.tap: bifrost2demo.tap
	$(APPMAKE) +zx -b bifrost2demo_BIFROST2.bin -o bifrost2.tap --noloader --org 51625 --blockname BIFROST2


bifrost2demo.tap: bifrost2demo.bin
	$(APPMAKE) +zx -b bifrost2demo.bin -o bifrost2demo.tap --noloader --org 32768 --blockname bifrost2dm


bifrost2demo.bin:
	zcc +zx $(COMPILER) $(CFLAGS)  bifrost2demo.c ctile.asm -o bifrost2demo.bin -lndos



clean:
	$(RM) bifrost*.bin bifrost*.tap  demo.tap
