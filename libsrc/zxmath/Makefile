#
# ZX ROM FP math Makefile
# $Id: Makefile,v 1.1 2003-03-24 09:17:39 stefano Exp $
#


all: mzx_tiny m81_tiny

mzx_tiny:
	rm -f *.o* ../mzx_tiny.lib
	z80asm -d -ns -nm -Mo -DFORzx -DTINYMODE -x../mzx_tiny @zxmlist
	cp ../mzx_tiny.lib ../../lib/clibs

m81_tiny:
	rm -f *.o* ../m81_tiny.lib
	z80asm -d -ns -nm -Mo -DFORzx81 -DTINYMODE -x../m81_tiny @zxmlist
	cp ../m81_tiny.lib ../../lib/clibs

mzx:
	rm -f *.o* ../mzx.lib
	z80asm -d -ns -nm -Mo -DFORzx -x../mzx @zxmlist
	cp ../mzx.lib ../../lib/clibs

m81:
	rm -f *.o* ../m81.lib
	z80asm -d -ns -nm -Mo -DFORzx81 -x../m81 @zxmlist
	cp ../81_math.lib ../../lib/clibs

clean:
	rm -f *.o* *.sym *.map *.err 

