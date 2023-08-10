include ../../../Make.config

default: sp1-all

sp1-all:
	@echo
	@echo --- SP1 Software Sprite Engine ---
	# newlib and sccz80 + classic libraries
	$(LIBLINKER2) -x$(OUTPUT_DIRECTORY)/sp1-ts2068 @ts2068hr.lst
	$(LIBLINKER2) -x$(OUTPUT_DIRECTORY)/sp1-zx81hr -IXIY @zx81hr.lst
	# sdcc + classic library
	$(MAKE) -C zx all
	cp zx/sp1-zx.lib $(OUTPUT_DIRECTORY)

clean:
	@$(MAKE) -C zx clean
	$(RM) *.o
	$(RM) deprecated/ts2068hr/sprites/*.o
	$(RM) deprecated/ts2068hr/sprites/draw/*.o
	$(RM) deprecated/ts2068hr/tiles/*.o
	$(RM) deprecated/ts2068hr/updater/*.o
	$(RM) deprecated/ts2068hr/sp1.lib
	$(RM) deprecated/zx81hr/sprites/*.o
	$(RM) deprecated/zx81hr/sprites/draw/*.o
	$(RM) deprecated/zx81hr/tiles/*.o
	$(RM) deprecated/zx81hr/updater/*.o
	$(RM) deprecated/zx81hr/sp1.lib
