# Z88DK - Rabbit Control Module examples
#
# $Id: Makefile,v 1.4 2009-05-07 14:52:31 mimarob Exp $

# You NEED to set this to your baudrate divisor and your serial port
SERDEVICE=/dev/ttyXXX
BAUD_DIV=XXX


all: example.bin twinkle2000.bin twinkle3000.bin iolib_twinkle3000.bin

SUPPORT=/usr/local/lib/z88dk/support/rcmx000



example.bin: example.c
	zcc +rcmx000 -oexample.bin example.c


twinkle2000.bin:
	zcc +rcmx000 -otwinkle2000.bin twinkle2000.c

twinkle3000.bin:
	zcc +rcmx000 -otwinkle3000.bin twinkle3000.c

iolib_twinkle3000.bin:
	zcc +rcmx000 -oiolib_twinkle3000.bin iolib.c iolib_twinkle3000.c

run_example:
	$(SUPPORT)/boot -b $(SERDEVICE) $(BAUD_DIV) example.bin

run_twinkle2000:
	$(SUPPORT)/boot -b $(SERDEVICE) $(BAUD_DIV) twinkle2000.bin

run_twinkle3000:
	$(SUPPORT)/boot -b $(SERDEVICE) $(BAUD_DIV) twinkle3000.bin

run_iolib_twinkle3000:
	$(SUPPORT)/boot -b $(SERDEVICE) $(BAUD_DIV) iolib_twinkle3000.bin

clean:
	rm -f *.bin ; rm -f *.LOD ; rm -f tmp_* ; rm -f zcc_opt.def ; \
        rm -f *~ ; rm -f #* ; rm -f *#

