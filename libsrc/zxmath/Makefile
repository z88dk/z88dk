#
# ZX ROM FP math Makefile
# $Id: Makefile,v 1.2 2003-08-30 19:15:28 dom Exp $
#


all: mzx_tiny m81_tiny

mzx_tiny:
	rm -f *.o* ../mzx_tiny.lib
	z80asm -d -ns -nm -Mo -DFORzx -DTINYMODE -x../mzx_tiny @zxmlist

m81_tiny:
	rm -f *.o* ../m81_tiny.lib
	z80asm -d -ns -nm -Mo -DFORzx81 -DTINYMODE -x../m81_tiny @zxmlist

mzx:
	rm -f *.o* ../mzx.lib
	z80asm -d -ns -nm -Mo -DFORzx -x../mzx @zxmlist

m81:
	rm -f *.o* ../m81.lib
	z80asm -d -ns -nm -Mo -DFORzx81 -x../m81 @zxmlist

clean:
	rm -f *.o* *.sym *.map *.err 

