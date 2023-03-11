# Classic compilation
#
ZCC = zcc +msx -subtype=rom -vn -m -s --list $(CFLAGS)			# SCCZ80
#ZCC = zcc +msx -subtype=rom -vn -compiler=sdcc -m -s --list $(CFLAGS) 	# SDCC

# Newlib compilation
#
#ZCC = zcc +msx -subtype=rom -vn -clib=new -m -s --list $(CFLAGS) 		# SCCZ80
#ZCC = zcc +msx -subtype=rom -vn -clib=sdcc_ix -m -s --list $(CFLAGS) 	# SDCC
#ZCC = zcc +msx -subtype=rom -vn -clib=sdcc_iy -m -s --list $(CFLAGS) 	# SDCC

CFLAGS = -DARKOS_USE_ROM_PLAYER

EXAMPLES = interrupt-rom periodic-rom

.PHONY: all clean

all: $(EXAMPLES:=.rom)

%.rom: %.o hocuspocus.o
	$(ZCC) $*.o hocuspocus.o -create-app -o $*

%.o: %.c
	$(ZCC) -c $*.c

%.o: %.asm
	$(ZCC) -c $*.asm

clean:
	@-rm *.lis *.bin *.o *.sym *.map *.tap *.cas *.rom $(EXAMPLES) 2>/dev/null
