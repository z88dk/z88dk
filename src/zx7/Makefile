
INSTALL ?= install

OBJS = compress.c  optimize.c  zx7.c


all: zx7$(EXESUFFIX) dzx7$(EXESUFFIX)

zx7$(EXESUFFIX):	$(OBJS)
	$(CC) -o zx7$(EXESUFFIX) $(LDFLAGS) $(OBJS)

dzx7$(EXESUFFIX):	dzx7.c
	$(CC) -o dzx7$(EXESUFFIX) $(LDFLAGS) dzx7.c

install:
	$(INSTALL) zx7$(EXESUFFIX) $(PREFIX)/bin/$(EXEC_PREFIX)zx7$(EXESUFFIX)
	$(INSTALL) dzx7$(EXESUFFIX) $(PREFIX)/bin/$(EXEC_PREFIX)dzx7$(EXESUFFIX)

clean:
	$(RM) zx7$(EXESUFFIX) zx7.o core$(EXESUFFIX)
	$(RM) dzx7$(EXESUFFIX) dzx7.o
	$(RM) -rf Debug Release


#Dependencies

zx7.o: zx7.c 
