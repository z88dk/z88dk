#
# $Id
#


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

INSTALL ?= install
	
all: z80asm$(EXESUFFIX)


z80asm$(EXESUFFIX): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o z80asm$(EXESUFFIX)  $(OBJS)

install:
	$(INSTALL) z80asm$(EXESUFFIX) $(PREFIX)/bin/


clean :
	$(RM) *.o *~ core z80asm$(EXESUFFIX)

# Dependencies
asmdrctv.o: asmdrctv.c symbol.h avltree.h config.h
avltree.o: avltree.c avltree.h
exprprsr.o: exprprsr.c symbol.h avltree.h config.h
hist.o: hist.c
ldinstr.o: ldinstr.c symbol.h avltree.h config.h
modlink.o: modlink.c symbol.h avltree.h config.h
prsident.o: prsident.c symbol.h avltree.h config.h
prsline.o: prsline.c symbol.h avltree.h config.h
symbols.o: symbols.c symbol.h avltree.h config.h
z80asm.o: z80asm.c symbol.h avltree.h config.h
z80instr.o: z80instr.c symbol.h avltree.h config.h
z80pass.o: z80pass.c symbol.h avltree.h config.h
