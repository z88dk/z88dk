#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.17 2008-07-17 15:39:56 stefano Exp $


lx11:
	cd x11 ; $(MAKE) ; cd ..

lc128:
	cd c128 ; $(MAKE) ; cd ..
	cd c128_64K ; $(MAKE) ; cd ..

clean:
	$(RM) *.o
	$(RM) 8080/*.o
	$(RM) abc80/*.o
	$(RM) ace/*.o
	$(RM) aquarius/*.o
	$(RM) c128/*.o
	$(RM) cpc/*.o
	$(RM) gray/*.o
	$(RM) gray/ticalc/*.o
	$(RM) gray/cpc/*.o
	$(RM) gray/zx81/*.o
	$(RM) msx/*.o
	$(RM) mz/*.o
	$(RM) nascom/*.o
	$(RM) oz/*.o
	$(RM) sam/*.o
	$(RM) spectrum/*.o
	$(RM) text/*.o
	$(RM) text6/*.o
	$(RM) ticalc/*.o
	$(RM) trs80/*.o
	$(RM) vz200/*.o
	$(RM) z88/*.o
	$(RM) zx81/*.o
	$(RM) zx81/hr/*.o
	cd x11 ; $(MAKE) clean ; cd ..
