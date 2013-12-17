
INSTALL ?= install

OBJS = scanner.o


all: scanner$(EXESUFFIX)

scanner$(EXESUFFIX):	$(OBJS)
	$(CC) -o scanner$(EXESUFFIX) $(LDFLAGS) $(OBJS)

install:
	$(INSTALL) scanner$(EXESUFFIX) $(PREFIX)/bin

clean:
	$(RM) scanner$(EXESUFFIX) scanner.o core$(EXESUFFIX)
	$(RM) -rf Debug Release


#Dependencies

scanner.o: scanner.c 
