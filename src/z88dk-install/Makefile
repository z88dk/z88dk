
INSTALL ?= install

OBJS = z88dk-install.o


all: z88dk-install$(EXESUFFIX)

z88dk-install$(EXESUFFIX):	$(OBJS)
	$(CC) -o z88dk-install$(EXESUFFIX) $(LDFLAGS) $(OBJS)

install:
	$(INSTALL) z88dk-install$(EXESUFFIX) $(PREFIX)/bin/$(EXEC_PREFIX)z88dk-install$(EXESUFFIX)

clean:
	$(RM) z88dk-install$(EXESUFFIX) z88dk-install.o core$(EXESUFFIX)
	$(RM) -rf Debug Release


#Dependencies

z88dk-install.o: z88dk-install.c 
