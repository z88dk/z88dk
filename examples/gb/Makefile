


all:	galaxy.bin paint.bin



%.bin: %.c
	zcc +gb -create-app -o $@ $^


clean:
	$(RM) -f *.bin *.gb zcc_opt.def
