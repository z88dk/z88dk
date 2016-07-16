all build run clean tidy:
ifeq ($(MONOLITHIC),on)
	$(MAKE) -C source $@
else
	$(MAKE) -C portability $@
	$(MAKE) -C persistence $@
	$(MAKE) -C strings $@
	$(MAKE) -C subsystems $@
endif
ifneq ($(TESTS),off)
	@if [ -d tests ]; then $(MAKE) -C tests $@; fi
endif

