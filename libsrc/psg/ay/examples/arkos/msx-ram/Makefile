# Classic compilation
#
ZCC = zcc +msx -vn -m -s --list				# SCCZ80
#ZCC = zcc +msx -vn -compiler=sdcc -m -s --list		# SDCC

# Newlib compilation
#
#ZCC = zcc +msx -vn -clib=new -m -s --list		# SCCZ80
#ZCC = zcc +msx -vn -clib=sdcc_ix -m -s --list		# SDCC
#ZCC = zcc +msx -vn -clib=sdcc_iy -m -s --list		# SDCC

EXAMPLES = interrupt-ram periodic-ram

.PHONY: all clean

all: $(EXAMPLES:=.cas)

%.cas: %.o hocuspocus.o
	$(ZCC) $*.o hocuspocus.o -create-app -o $*

%.o: %.c
	$(ZCC) -c $*.c

%.o: %.asm
	$(ZCC) -c $*.asm

clean:
	@-rm *.lis *.bin *.o *.sym *.map *.tap *.cas *.rom $(EXAMPLES) 2>/dev/null
