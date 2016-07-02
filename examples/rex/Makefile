

all:  hello.rex

%.rex: %.c
	zcc +rex -vn -create-app -o $(@:.rex=.bin) $^

clean:
	$(RM) -f *.rex *.bin *.reloc zcc_opt.def
