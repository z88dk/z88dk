# main target objs
MAIN_OBJS = main.o  hocuspocus.o

ZCC = zcc +zx -vn -s --list

# targets
.PHONY: build clean

build: $(MAIN_OBJS)
	$(ZCC) -m -create-app -o arkos $(MAIN_OBJS)

%.o: %.c
	$(ZCC) -c $*.c

%.o: %.asm
	$(ZCC) -c $*.asm

clean:
	@-rm *.lis *.bin *.tap *.o *.sym $(ARKOS_ASM) $(PASMO_ASM) $(Z88DK_ASM) *.map *.save arkos 2>/dev/null
