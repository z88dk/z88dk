
INSTALL ?= install

OBJS = scanner.o


all: zpragma$(EXESUFFIX)

zpragma$(EXESUFFIX):	$(OBJS)
	$(CC) -o zpragma$(EXESUFFIX) $(LDFLAGS) $(OBJS)

install:
	$(INSTALL) zpragma$(EXESUFFIX) $(PREFIX)/bin

clean:
	$(RM) zpragma$(EXESUFFIX) scanner.o core$(EXESUFFIX)
	$(RM) -rf Debug Release


#Dependencies

scanner.o: scanner.c 
