
OBJS = copt.o


all: copt$(EXESUFFIX)

copt:	$(OBJS)
	$(CC) -o copt$(EXESUFFIX) $(LDFLAGS) $(OBJS)

install:
	install copt$(EXESUFFIX) $(PREFIX)/bin

clean:
	$(RM) copt copt.o core$(EXESUFFIX)


#Dependencies

copt.o: copt.c 
