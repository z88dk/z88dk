#
# ZX ROM FP math Makefile
# $Id: Makefile,v 1.3 2003-09-11 10:20:30 dom Exp $
#


all: zx_mathtiny zx81_mathtiny zx_math zx81_math

zx_mathtiny:
	rm -f *.o* ../mzx_tiny.lib
	z80asm -d -ns -nm -Mo -DFORzx -DTINYMODE -x../zx_mathtiny @zxmlist

zx81_mathtiny:
	rm -f *.o* ../m81_tiny.lib
	z80asm -d -ns -nm -Mo -DFORzx81 -DTINYMODE -x../zx81_mathtiny @zxmlist

zx_math:
	rm -f *.o* ../mzx.lib
	z80asm -d -ns -nm -Mo -DFORzx -x../zx_math @zxmlist

zx81_math:
	rm -f *.o* ../m81.lib
	z80asm -d -ns -nm -Mo -DFORzx81 -x../zx81_math @zxmlist

clean:
	rm -f *.o* *.sym *.map *.err 

