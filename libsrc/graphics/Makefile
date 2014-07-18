#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.35 2014-07-18 06:18:08 stefano Exp $


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
	$(RM) 8080/*.o
	$(RM) abc80/*.o
	$(RM) ace/*.o
	$(RM) aquarius/*.o
	cd c128 ; $(MAKE) clean ; cd ..
	cd c128_64k ; $(MAKE) clean ; cd ..
	$(RM) cpc/*.o
	cd enterprise ; $(MAKE) clean ; cd ..
	cd enterprise_hr ; $(MAKE) clean ; cd ..
	$(RM) gal/*.o
	$(RM) gray/*.o
	$(RM) gray/ticalc/*.o
	$(RM) gray/cpc/*.o
	$(RM) gray/zx81/*.o
	$(RM) mc1000/*.o
	$(RM) msx/*.o
	$(RM) msx/surface/*.o
	$(RM) mz/*.o
	$(RM) nascom/*.o
	$(RM) osca/*.o
	$(RM) oz/*.o
	$(RM) p2000/*.o
	$(RM) pc6001/*.o
	$(RM) sam/*.o
	$(RM) sorcerer/*.o
	$(RM) spectrum/*.o
	$(RM) text/*.o
	$(RM) text6/*.o
	$(RM) ticalc/*.o
	$(RM) trs80/*.o
	$(RM) ts2068hr/*.o
	$(RM) vz200/*.o
	$(RM) z88/*.o
	$(RM) zx80/*.o
	$(RM) time/zx81/*.o
	$(RM) zx81/*.o
	$(RM) zx81/hr/*.o
	$(RM) zx81/udg/*.o
	cd x11 ; $(MAKE) clean ; cd ..
