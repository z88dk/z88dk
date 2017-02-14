#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.46 2016-11-21 11:18:37 stefano Exp $


lx11:
	cd x11 ; $(MAKE) ; cd ..

lc128:
	cd c128 ; $(MAKE) ; cd ..
	cd c128_64k ; $(MAKE) ; cd ..

lenterprise:
	cd enterprise ; $(MAKE) ; cd ..

lenterprisehr:
	cd enterprise_hr ; $(MAKE) ; cd ..

clean:
	$(RM) *.o
	$(RM) */*.o
	cd c128 ; $(MAKE) clean ; cd ..
	cd c128_64k ; $(MAKE) clean ; cd ..
	cd enterprise ; $(MAKE) clean ; cd ..
	cd enterprise_hr ; $(MAKE) clean ; cd ..
	$(RM) gray/ticalc/*.o
	$(RM) gray/cpc/*.o
	$(RM) gray/zx81/*.o
	$(RM) msx/surface/*.o
	$(RM) spectrum/cpm/*.o
	$(RM) zx81/hr/*.o
	$(RM) zx81/udg/*.o
	cd x11 ; $(MAKE) clean ; cd ..
