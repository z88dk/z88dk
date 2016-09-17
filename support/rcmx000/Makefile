
# You NEED to set this to your serial port
SERDEVICE=/dev/ttyXXX

all: boot mk_boot_code RCMX000_BOOT.LOD BAUDMEAS.LOD

boot: boot.c bootbytes.h mysock.c mysock.h
	gcc -o boot boot.c mysock.c

OPTS=-DDEFINED_NOFLASH 


mk_coldboot_hfile: mk_coldboot_hfile.c
	gcc -o mk_coldboot_hfile mk_coldboot_hfile.c

mk_boot_code: mk_boot_code.c
	gcc -o mk_boot_code mk_boot_code.c

bootbytes.h: mk_coldboot_hfile RCMX000_BOOT.LOD
	./mk_coldboot_hfile RCMX000_BOOT.LOD > bootbytes.h

rcmx000_boot.o: rcmx000_boot.asm
	z80asm $(OPTS) rcmx000_boot.asm

rcmx000_boot.bin: rcmx000_boot.o
	z80asm $(OPTS) -a -m -orcmx000_boot.bin rcmx000_boot.o

rcmx000_boot.asm:
	ln -s ../../lib/rcmx000_boot.asm .

# The .LOD file used for all normal user programs
RCMX000_BOOT.LOD: rcmx000_boot.bin mk_boot_code
	./mk_boot_code rcmx000_boot.map rcmx000_boot.bin RCMX000_BOOT.LOD


# The .LOD file for obtaining the baudrate divisor
BAUDMEAS.LOD: baudmeas.bin mk_boot_code
	./mk_boot_code -r rcmx000_boot.sym baudmeas.bin BAUDMEAS.LOD

# -s generates a symbol table which we use later...
# We disable the flash code here since we dont need it.
# We will download this at 2400 and saving 2k means about 10 seconds
# faster reply time
baudmeas.bin: baudmeas.c
	zcc +rcmx000 -Ca-DDEFINED_NOFLASH -s -obaudmeas.bin baudmeas.c


# Use this to find out the baudrate of your Rabbit, but you only can know
# the tty device!!
run_baudmeas:
	./boot -r $(SERDEVICE) BAUDMEAS.LOD

clean:
	rm -f *.o boot mk_boot_code *.sym *.map *.LOD *.bin rcmx000_boot.asm mk_coldboot_hfile bootbytes.h tmp_* zcc_opt.def *.obj *~ rcmx000_flash.asm rcmx000_flutil.asm

