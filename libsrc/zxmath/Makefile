#
# ZX ROM FP math Makefile
# $Id: Makefile,v 1.6 2007-06-03 15:13:07 stefano Exp $
#

include ../Make.config

all: zx_mathtiny zx81_mathtiny zx_math zx81_math

zx_mathtiny:
	rm -f *.o* ../mzx_tiny.lib
	$(LIBLINKER) -DFORzx -DTINYMODE -x$(OUTPUT_DIRECTORY)/mzx_tiny @zxmlist

zx81_mathtiny:
	rm -f *.o* ../m81_tiny.lib
	$(LIBLINKER) -DFORzx81 -DTINYMODE -x$(OUTPUT_DIRECTORY)/m81_tiny @zxmlist

zx_math:
	rm -f *.o* ../mzx.lib
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/mzx @zxmlist

zx81_math:
	rm -f *.o* ../m81.lib
	$(LIBLINKER) -DFORzx81 -x$(OUTPUT_DIRECTORY)/m81 @zxmlist

clean:
	rm -f *.o* *.sym *.map *.err 

