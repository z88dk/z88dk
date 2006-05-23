#
# ZX ROM FP math Makefile
# $Id: Makefile,v 1.4 2006-05-23 19:45:32 stefano Exp $
#


all: zx_mathtiny zx81_mathtiny zx_math zx81_math

zx_mathtiny:
	rm -f *.o* ../mzx_tiny.lib
	z80asm -d -ns -nm -Mo -DFORzx -DTINYMODE -x../mzx_tiny @zxmlist

zx81_mathtiny:
	rm -f *.o* ../m81_tiny.lib
	z80asm -d -ns -nm -Mo -DFORzx81 -DTINYMODE -x../m81_tiny @zxmlist

zx_math:
	rm -f *.o* ../mzx.lib
	z80asm -d -ns -nm -Mo -DFORzx -x../mzx @zxmlist

zx81_math:
	rm -f *.o* ../m81.lib
	z80asm -d -ns -nm -Mo -DFORzx81 -x../m81 @zxmlist

clean:
	rm -f *.o* *.sym *.map *.err 

