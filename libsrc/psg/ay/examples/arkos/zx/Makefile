# Classic compilation
#
ZCC = zcc +zx -vn -m -s --list				# SCCZ80
#ZCC = zcc +zx -vn -compiler=sdcc -m -s --list		# SDCC

# Newlib compilation
#
#ZCC = zcc +zx -vn -clib=new -m -s --list		# SCCZ80
#ZCC = zcc +zx -vn -clib=sdcc_ix -m -s --list		# SDCC
#ZCC = zcc +zx -vn -clib=sdcc_iy -m -s --list		# SDCC

EXAMPLES = interrupt periodic

.PHONY: all clean

all: $(EXAMPLES:=.tap)

%.tap: %.o hocuspocus.o
	$(ZCC) $*.o hocuspocus.o -create-app -o $*

%.o: %.c
	$(ZCC) -c $*.c

%.o: %.asm
	$(ZCC) -c $*.asm

clean:
	@-rm *.lis *.bin *.o *.sym *.map *.tap *.cas *.rom $(EXAMPLES) 2>/dev/null
