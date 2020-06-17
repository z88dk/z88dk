


all:	sgdemo.bin 



%.bin: %.c
	zcc +c128 -create-app -o $@ $^


clean:
	$(RM) -f *.bin *.T64 zcc_opt.def
