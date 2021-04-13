include ../../../Make.config

default: sp1-all

sp1-all:
	@echo
	@echo --- SP1 Software Sprite Engine ---
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/sp1 @spectrum.lst
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/sp1-ts2068 @ts2068hr.lst
	$(LIBLINKER) -x$(OUTPUT_DIRECTORY)/sp1-zx81hr -IXIY @zx81hr.lst


clean:
	$(RM) *.o
	$(RM) spectrum/sprites/*.o
	$(RM) spectrum/sprites/draw/*.o
	$(RM) spectrum/tiles/*.o
	$(RM) spectrum/updater/*.o
	$(RM) spectrum/sp1.lib
	$(RM) ts2068hr/sprites/*.o
	$(RM) ts2068hr/sprites/draw/*.o
	$(RM) ts2068hr/tiles/*.o
	$(RM) ts2068hr/updater/*.o
	$(RM) ts2068hr/sp1.lib
	$(RM) zx81hr/sprites/*.o
	$(RM) zx81hr/sprites/draw/*.o
	$(RM) zx81hr/tiles/*.o
	$(RM) zx81hr/updater/*.o
	$(RM) zx81hr/sp1.lib
