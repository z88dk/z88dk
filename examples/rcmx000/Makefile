# Z88DK - Rabbit Control Module examples
#
# $Id: Makefile,v 1.1 2007-02-28 11:23:14 stefano Exp $

# You NEED to set this to your baudrate divisor and your serial port
SERDEVICE=/dev/ttyXXX
BAUD_DIV=XXX


all: EXAMPLE.LOD BAUDMEAS.LOD TWINKLE2000.LOD TWINKLE3000.LOD



SUPPORT=/usr/local/lib/z88dk/support/rcmx000

EXAMPLE.LOD: example.bin
	$(SUPPORT)/mk_boot_code tmp_rcmx000_crt0.sym example.bin EXAMPLE.LOD

example.bin: tmp_example.o
	rm -f a.bin ; $(SUPPORT)/link_any.sh tmp_example.o ; mv a.bin example.bin

tmp_example.o: example.c
	$(SUPPORT)/compile_any.sh example

TWINKLE2000.LOD: twinkle2000.bin
	$(SUPPORT)/mk_boot_code tmp_rcmx000_crt0.sym twinkle2000.bin TWINKLE2000.LOD

twinkle2000.bin: tmp_twinkle2000.o
	rm -f a.bin ; $(SUPPORT)/link_any.sh tmp_twinkle2000.o ; mv a.bin twinkle2000.bin

tmp_twinkle2000.o: twinkle2000.c
	$(SUPPORT)/compile_any.sh twinkle2000

TWINKLE3000.LOD: twinkle3000.bin
	$(SUPPORT)/mk_boot_code tmp_rcmx000_crt0.sym twinkle3000.bin TWINKLE3000.LOD

twinkle3000.bin: tmp_twinkle3000.o
	rm -f a.bin ; $(SUPPORT)/link_any.sh tmp_twinkle3000.o ; mv a.bin twinkle3000.bin

tmp_twinkle3000.o: twinkle3000.c
	$(SUPPORT)/compile_any.sh twinkle3000

BAUDMEAS.LOD: baudmeas.bin
	$(SUPPORT)/mk_boot_code -r tmp_rcmx000_crt0.sym baudmeas.bin BAUDMEAS.LOD

baudmeas.bin: tmp_baudmeas.o
	rm -f a.bin ; $(SUPPORT)/link_any.sh tmp_baudmeas.o ; mv a.bin baudmeas.bin

tmp_baudmeas.o: baudmeas.c baudmeas.asm
	$(SUPPORT)/compile_any.sh baudmeas


# Use this to find out the baudrate of your Rabbit, but you only can know
# the tty device!!
run_baudmeas:
	$(SUPPORT)/boot $(SERDEVICE) 0 -r BAUDMEAS.LOD baudmeas.bin

# Below you need to patch in your baud divisor instead of XXX and your serial port
run_example:
	$(SUPPORT)/boot $(SERDEVICE) $(BAUD_DIV) -b EXAMPLE.LOD example.bin

run_twinkle2000:
	$(SUPPORT)/boot $(SERDEVICE) $(BAUD_DIV) -b TWINKLE2000.LOD twinkle2000.bin

run_twinkle3000:
	$(SUPPORT)/boot $(SERDEVICE) $(BAUD_DIV) -b TWINKLE3000.LOD twinkle3000.bin

clean:
	rm -f *.bin ; rm -f *.LOD ; rm -f tmp_* ; rm -f zcc_opt.def ; \
        rm -f *~ ; rm -f #* ; rm -f *#

