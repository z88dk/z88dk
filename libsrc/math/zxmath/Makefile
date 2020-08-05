#
# ZX ROM FP math Makefile
# $Id: Makefile,v 1.3 2016-07-02 15:42:55 dom Exp $
#

include ../../Make.config

all: mzx_tiny m81_tiny mlambda_tiny mzx m2068 m81 mlambda

mzx_tiny:
	$(RM) -f *.o* ../../mzx_tiny.lib
	$(LIBLINKER) -DFORzx -DTINYMODE -x$(OUTPUT_DIRECTORY)/mzx_tiny @zxmlist

m81_tiny:
	$(RM) -f *.o* ../../m81_tiny.lib
	$(LIBLINKER) -DFORzx81 -IXIY -DTINYMODE -x$(OUTPUT_DIRECTORY)/m81_tiny @zxmlist

mlambda_tiny:
	$(RM) -f *.o* ../../mlambda_tiny.lib
	$(LIBLINKER) -DFORlambda -IXIY -DTINYMODE -x$(OUTPUT_DIRECTORY)/mlambda_tiny @zxmlist

mzx:
	$(RM) -f *.o* ../../mzx.lib
	$(LIBLINKER) -DFORzx -x$(OUTPUT_DIRECTORY)/mzx @zxmlist

m2068:
	$(RM) -f *.o* ../../m2068.lib
	$(LIBLINKER) -DFORts2068 -x$(OUTPUT_DIRECTORY)/m2068 @zxmlist

m81:
	$(RM) -f *.o* ../../m81.lib
	$(LIBLINKER) -DFORzx81 -IXIY -x$(OUTPUT_DIRECTORY)/m81 @zxmlist

mlambda:
	$(RM) -f *.o* ../../mlambda.lib
	$(LIBLINKER) -DFORlambda -IXIY -x$(OUTPUT_DIRECTORY)/mlambda @zxmlist

clean:
	$(RM) -f *.o* *.sym *.map *.err 

