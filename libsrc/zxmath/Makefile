#
# ZX ROM FP math Makefile
# $Id: Makefile,v 1.7 2007-10-05 07:38:33 stefano Exp $
#

include ../Make.config

all: mzx_tiny m81_tiny mzx m81

mzx_tiny:
	rm -f *.o* ../mzx_tiny.lib
	$(LIBLINKER) -DFORzx -DTINYMODE -x../$(OUTPUT_DIRECTORY)/mzx_tiny @zxmlist

m81_tiny:
	rm -f *.o* ../m81_tiny.lib
	$(LIBLINKER) -DFORzx81 -DTINYMODE -x../$(OUTPUT_DIRECTORY)/m81_tiny @zxmlist

mzx:
	rm -f *.o* ../mzx.lib
	$(LIBLINKER) -DFORzx -x../$(OUTPUT_DIRECTORY)/mzx @zxmlist

m81:
	rm -f *.o* ../m81.lib
	$(LIBLINKER) -DFORzx81 -x../$(OUTPUT_DIRECTORY)/m81 @zxmlist

clean:
	rm -f *.o* *.sym *.map *.err 

