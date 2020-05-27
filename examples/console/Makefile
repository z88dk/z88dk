

# This is a slightly horrible way of doing it, but we get to test out
# the multitarget makefile
all:
	$(MAKE) -f Makefile.world && $(MAKE) -f Makefile.conio && $(MAKE) -f Makefile.ansi

clean:
	$(MAKE) -f Makefile.world clean && $(MAKE) -f Makefile.conio clean && $(MAKE) -f Makefile.ansi clean

