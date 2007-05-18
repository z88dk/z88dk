# Z88DK - Rabbit Control Module examples
#
# $Id: Makefile,v 1.2 2007-05-18 06:36:50 stefano Exp $

# You NEED to set this to your baudrate divisor and your serial port
SERDEVICE=/dev/ttyXXX
BAUD_DIV=XXX


all: example.bin twinkle2000.bin twinkle3000.bin

SUPPORT=/usr/local/lib/z88dk/support/rcmx000



example.bin: example.c
	zcc +rcmx000 -oexample.bin example.c


twinkle2000.bin:
	zcc +rcmx000 -otwinkle2000.bin twinkle2000.c

twinkle3000.bin:
	zcc +rcmx000 -otwinkle3000.bin twinkle3000.c


run_example:
	$(SUPPORT)/boot $(SERDEVICE) $(BAUD_DIV) -b EXAMPLE.LOD example.bin

run_twinkle2000:
	$(SUPPORT)/boot $(SERDEVICE) $(BAUD_DIV) -b TWINKLE2000.LOD twinkle2000.bin

run_twinkle3000:
	$(SUPPORT)/boot $(SERDEVICE) $(BAUD_DIV) -b TWINKLE3000.LOD twinkle3000.bin

clean:
	rm -f *.bin ; rm -f *.LOD ; rm -f tmp_* ; rm -f zcc_opt.def ; \
        rm -f *~ ; rm -f #* ; rm -f *#

