#

include ../Make.config

lx11:
	$(MAKE) -C x11

lc128:
	$(MAKE) -C c128
	$(MAKE) -C c128_64k

clean:
	$(RM) *.o
	$(RM) */*.o
	$(RM) */*/*.o
	$(MAKE) -C c128 clean
	$(MAKE) -C c128_64k clean
	$(MAKE) -C x11 clean
	$(RM) gray/cpc/*.o
	$(RM) msx/surface/*.o
	$(RM) spectrum/cpm/*.o
