#
# ZX ROM FP math Makefile
# $Id: Makefile,v 1.5 2006-06-18 14:55:44 dom Exp $
#

include ../Make.config

all: zx_mathtiny zx81_mathtiny zx_math zx81_math

zx_mathtiny:
	rm -f *.o* ../mzx_tiny.lib
	$(LIBLINKER) -DFORzx -DTINYMODE -x../mzx_tiny @zxmlist

zx81_mathtiny:
	rm -f *.o* ../m81_tiny.lib
	$(LIBLINKER) -DFORzx81 -DTINYMODE -x../m81_tiny @zxmlist

zx_math:
	rm -f *.o* ../mzx.lib
	$(LIBLINKER) -DFORzx -x../mzx @zxmlist

zx81_math:
	rm -f *.o* ../m81.lib
	$(LIBLINKER) -DFORzx81 -x../m81 @zxmlist

clean:
	rm -f *.o* *.sym *.map *.err 

