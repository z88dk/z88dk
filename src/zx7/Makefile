
INSTALL ?= install

OBJS = compress.c  optimize.c  zx7.c


all: copt$(EXESUFFIX)

copt$(EXESUFFIX):	$(OBJS)
	$(CC) -o zx7$(EXESUFFIX) $(LDFLAGS) $(OBJS)

install:
	$(INSTALL) zx7$(EXESUFFIX) $(PREFIX)/bin

clean:
	$(RM) zx7$(EXESUFFIX) zx7.o core$(EXESUFFIX)
	$(RM) -rf Debug Release


#Dependencies

zx7.o: zx7.c 
