
OBJS = copt.o


all: copt$(EXESUFFIX)

copt$(EXESUFFIX):	$(OBJS)
	$(CC) -o copt$(EXESUFFIX) $(LDFLAGS) $(OBJS)

install:
	install copt$(EXESUFFIX) $(PREFIX)/bin

clean:
	$(RM) copt$(EXESUFFIX) copt.o core$(EXESUFFIX)
	$(RM) -rf Debug Release


#Dependencies

copt.o: copt.c 
