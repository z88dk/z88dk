#
# $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Makefile,v 1.10 2011-07-09 01:12:31 pauloscustodio Exp $
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
	
all: z80asm$(EXESUFFIX)


z80asm$(EXESUFFIX): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o z80asm$(EXESUFFIX)  $(OBJS)


install:
	install  z80asm$(EXESUFFIX) $(PREFIX)/bin/


clean :
	$(RM) *.o *~ *.bak core z80asm$(EXESUFFIX) test.*


# test
test : z80asm$(EXESUFFIX)
	perl -S prove t/*.t


# Dependencies
depend:
	makedepend -Y -- $(CFLAGS) -- $(OBJS:.o=.c)

# DO NOT DELETE

asmdrctv.o: config.h ../config.h symbol.h avltree.h z80asm.h
avltree.o: avltree.h
exprprsr.o: config.h ../config.h symbol.h avltree.h
hist.o: hist.h
ldinstr.o: config.h ../config.h z80asm.h symbol.h avltree.h
modlink.o: config.h ../config.h symbol.h avltree.h
prsident.o: config.h ../config.h z80asm.h symbol.h avltree.h
prsline.o: config.h ../config.h z80asm.h symbol.h avltree.h
symbols.o: config.h ../config.h symbol.h avltree.h
z80asm.o: config.h ../config.h symbol.h avltree.h z80asm.h hist.h
z80instr.o: config.h ../config.h z80asm.h symbol.h avltree.h
z80pass.o: config.h ../config.h symbol.h avltree.h hist.h
