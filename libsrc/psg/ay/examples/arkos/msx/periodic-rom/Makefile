# main target objs
MAIN_OBJS = main.o hocuspocus.o

ZCC = zcc +msx -subtype=rom -vn

# targets
.PHONY: build clean

build: $(MAIN_OBJS)
	$(ZCC) -m -s --list -create-app -o arkos $(MAIN_OBJS)

%.o: %.c
	$(ZCC) -c -s --list $*.c

%.o: %.asm
	$(ZCC) -c -s --list $*.asm

clean:
	@-rm *.lis *.bin *.tap *.o *.sym *.map *.save arkos *.rom 2>/dev/null
