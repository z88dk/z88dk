
# You NEED to set this to your serial port
SERDEVICE=/dev/ttyXXX

all: boot mk_boot_code _fix_perms RCMX000_BOOT.LOD BAUDMEAS.LOD

_fix_perms:
	chmod a+rx link_any.sh compile_any.sh

boot: boot.c bootbytes.h
	gcc -o boot boot.c

mk_coldboot_hfile: mk_coldboot_hfile.c
	gcc -o mk_coldboot_hfile mk_coldboot_hfile.c

mk_boot_code: mk_boot_code.c
	gcc -o mk_boot_code mk_boot_code.c

bootbytes.h: mk_coldboot_hfile RCMX000_BOOT.LOD
	./mk_coldboot_hfile RCMX000_BOOT.LOD > bootbytes.h

# Here we use some special utilities and assembler flags to make the .LOD file
# (same is now used for all users programs)
rcmx000_boot.o: rcmx000_boot.asm
	z80asm rcmx000_boot.asm

rcmx000_boot.bin: rcmx000_boot.o
	z80asm -a -m -Mo -orcmx000_boot.bin rcmx000_boot.o

rcmx000_boot.asm:
	ln -s ../../lib/rcmx000_boot.asm .

# The .LOD file used for all normal user programs
RCMX000_BOOT.LOD: rcmx000_boot.bin mk_boot_code
	./mk_boot_code rcmx000_boot.map rcmx000_boot.bin RCMX000_BOOT.LOD

BAUDMEAS.LOD: baudmeas.bin mk_boot_code
	./mk_boot_code -r tmp_rcmx000_crt0.sym baudmeas.bin BAUDMEAS.LOD

baudmeas.bin: tmp_baudmeas.o
	rm -f a.bin ; ./link_any.sh tmp_baudmeas.o ; mv a.bin baudmeas.bin

tmp_baudmeas.o: baudmeas.c baudmeas.asm
	./compile_any.sh baudmeas


# Use this to find out the baudrate of your Rabbit, but you only can know
# the tty device!!
run_baudmeas:
	./boot $(SERDEVICE) 0 -r BAUDMEAS.LOD

clean:
	rm -f *.o boot mk_boot_code *.sym *.map *.LOD *.bin rcmx000_boot.asm mk_coldboot_hfile bootbytes.h tmp_* zcc_opt.def *.obj *~

