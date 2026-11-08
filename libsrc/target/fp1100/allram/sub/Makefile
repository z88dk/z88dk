# The all-RAM console's sub-CPU program, its loader and the define file the Z80 side (and the loader) include.  The outputs are checked in, so
# building z88dk does not need this:  make   (in this directory; it uses the installed z88dk-asm7801, built from src/asm7801 by the top level make)
#
#   sub.bin     page 1 of the program, up to the P1End label (at most 256 bytes: the JB dispatch needs the commands' entry points in one page)
#   sub2.bin    the rest, from Page2 on, a multiple of 8 bytes (the takeover sends it 8 bytes at a time)
#   loader.bin  the ROM "run" command's loader (at most 40 bytes: five "define character" blocks), padded to 40
#   sub.inc     the PUBLIC labels of sub.s.in as z80asm DEFCs (SUB_ADDR, SUB_P1END, ...), INCLUDEd by loader.s.in and the Z80 sources
#   sub.map     all the labels

ASM ?= z88dk-asm7801
BASE = 9000                     # the program: spare VRAM, one page for the JB dispatch
BASE2 = 9100                    # the rest
PAGE = 90                       # BASE's high byte
LOADER = 3A60                   # where the ROM's "run" command ($6B) executes: blue plane, cell (4, 21)

all: sub.bin sub2.bin loader.bin

sub.all sub.inc sub.map: sub.s.in
	$(ASM) -DBASE='$$$(BASE)' -DPAGE='$$$(PAGE)' -DBASE2='$$$(BASE2)' \
		-o sub.all -m sub.map -d sub.inc -p SUB_ -U sub.s.in 0x$(BASE) > /dev/null

# an address from the map, relative to BASE
addr = $$(( 0x$$(awk '$$1=="$(1)" {print substr($$3, 2)}' sub.map) - 0x$(BASE) ))

sub.bin: sub.all sub.map
	p1=$(call addr,P1End); p2=$(call addr,Page2); \
	if [ $$p1 -gt 256 ] || [ $$p2 -ne 256 ]; then echo "sub program layout is wrong: page 1 $$p1 bytes, page 2 at $$p2"; exit 1; fi; \
	head -c $$p1 sub.all > $@

sub2.bin: sub.all
	tail -c +257 sub.all | dd bs=8 conv=sync of=$@ 2> /dev/null

loader.raw: loader.s.in sub.inc
	$(ASM) -o $@ loader.s.in 0x$(LOADER) > /dev/null

loader.bin: loader.raw
	if [ `wc -c < loader.raw` -gt 40 ]; then echo "the loader is over 40 bytes"; exit 1; fi; \
	dd bs=40 conv=sync if=loader.raw of=$@ 2> /dev/null

clean:
	$(RM) sub.all sub.map loader.raw
