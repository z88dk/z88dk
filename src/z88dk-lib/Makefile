
INSTALL ?= install

OBJS = z88dk-lib.o


all: z88dk-lib$(EXESUFFIX)

z88dk-lib$(EXESUFFIX):	$(OBJS)
	$(CC) -o z88dk-lib$(EXESUFFIX) $(LDFLAGS) $(OBJS)

install:
	$(INSTALL) z88dk-lib$(EXESUFFIX) $(PREFIX)/bin/z88dk-lib$(EXESUFFIX)

clean:
	$(RM) z88dk-lib$(EXESUFFIX) z88dk-lib.o core$(EXESUFFIX)
	$(RM) -rf Debug Release


#Dependencies

z88dk-lib.o: z88dk-lib.c 
