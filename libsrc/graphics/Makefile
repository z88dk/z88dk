#

include ../Make.config

lx11:
	$(MAKE) -C x11

clean:
	$(RM) *.o
	$(RM) */*.o
	$(RM) */*/*.o
	$(RM) zcc_opt.def
	$(RM) */zcc_opt.def
	$(MAKE) -C x11 clean
