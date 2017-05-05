
INSTALL ?= install

OBJS = zpragma.o


all: zpragma$(EXESUFFIX)

zpragma$(EXESUFFIX):	$(OBJS)
	$(CC) -o zpragma$(EXESUFFIX) $(LDFLAGS) $(OBJS)

install:
	$(INSTALL) zpragma$(EXESUFFIX) $(PREFIX)/bin/$(EXEC_PREFIX)zpragma$(EXESUFFIX)

clean:
	$(RM) zpragma$(EXESUFFIX) zpragma.o core$(EXESUFFIX)
	$(RM) -rf Debug Release


#Dependencies

zpragma.o: zpragma.c 
