
APPMAKE = z88dk-appmake
COMPILER = -compiler=sccz80


all: demo.tap




demo.tap: nirvanap.tap nirvanapdemo.tap
	cat loader.tap $^ > demo.tap


nirvanap.tap: nirvanapdemo.tap
	$(APPMAKE) +zx -b nirvanapdemo_NIRVANAP.bin -o nirvanap.tap --noloader --org 56323 --blockname NIRVANAP 


nirvanapdemo.tap: nirvanapdemo.bin
	$(APPMAKE) +zx -b nirvanapdemo.bin -o nirvanapdemo.tap --noloader --org 32768 --blockname nirvanadm


nirvanapdemo.bin:
	zcc +zx $(COMPILER) $(CFLAGS)  nirvanapdemo.c btile.asm -o nirvanapdemo.bin -lndos -m



clean:
	$(RM) nirvana*.bin nirvana*.tap  demo.tap
