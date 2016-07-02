

all: info.V00


info.V00: info.c
	zcc +zx -subtype=zxvgs -vn info.c -o info.bin -create-app -lzxvgs

clean:
	rm -f *.bin *.i *.asm *.op* *.o *~ zcc_opt.def *.V00
