# EXESUFFIX is passed when cross-compiling Win32 on Linux
ifeq ($(OS),Windows_NT)
  EXESUFFIX 		:= .exe
else
  EXESUFFIX 		?=
endif


CC = gcc

CFLAGS = -c -O3 -Wall
LFLAGS = -s

OBJ =   z80amain.o \
	z80atab.o \
	z80anum.o \
	z80aout.o \
	z80arfun.o \
	z80apfun.o \
	z80aopc.o \
	z80aglb.o

z80asm$(EXESUFFIX) : $(OBJ)
	$(CC) $(OBJ) $(LFLAGS) -o z80asm$(EXESUFFIX)

z80amain.o : z80amain.c z80a.h z80aglb.h
	$(CC) $(CFLAGS) z80amain.c

z80atab.o : z80atab.c z80a.h z80aglb.h
	$(CC) $(CFLAGS) z80atab.c

z80anum.o : z80anum.c z80a.h z80aglb.h
	$(CC) $(CFLAGS) z80anum.c

z80aout.o : z80aout.c z80a.h z80aglb.h
	$(CC) $(CFLAGS) z80aout.c

z80arfun.o : z80arfun.c z80a.h z80aglb.h
	$(CC) $(CFLAGS) z80arfun.c

z80apfun.o : z80apfun.c z80a.h z80aglb.h
	$(CC) $(CFLAGS) z80apfun.c

z80aopc.o : z80aopc.c z80a.h
	$(CC) $(CFLAGS) z80aopc.c

z80aglb.o : z80aglb.c z80a.h
	$(CC) $(CFLAGS) z80aglb.c

clean:
	rm -f core *.o z80asm$(EXESUFFIX)

install: z80asm$(EXESUFFIX)
	cp z80asm$(EXESUFFIX) ${HOME}/bin
