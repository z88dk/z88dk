#
# ITMA! Revisit for z80asm!
#


CC=gcc
CFLAGS = -O2 -Wall -s $(CCOPT) 
LDFLAGS=

OBJS = 	asmdrctv.o 	\
	avltree.o	\
	exprprsr.o	\
	hist.o		\
	ldinstr.o	\
	modlink.o	\
	prsident.o	\
	prsline.o	\
	symbols.o	\
	z80asm.o	\
	z80instr.o	\
	z80pass.o
	

EXECS = z80asm


.PHONY: all
ifeq (.depend,$(wildcard .depend))
all : $(EXECS)
include .depend
else
all:	depend
	@echo
	@echo Now do make again
	@echo
endif


z80asm : $(OBJS)
	$(CC) $(LDFLAGS) -o ../../bin/z80asm $(CFLAGS) $(OBJS)


clean :
	rm -f *.o *~ core $(EXECS) 

# ------------------------------------------------------------------------------
# Make the dependencies

.PHONY: depend dep
depend dep:	$(OBJS:.o=.c)
	@echo "Creating dependency information"
	$(CC) -MM $^ > .depend


