
INSTALL ?= install
OBJS=cpp1.o cpp2.o cpp3.o cpp4.o cpp5.o cpp6.o

ifeq (Darwin,$(shell uname)) 
    CFLAGS += -std=c89
endif

zcpp$(EXESUFFIX):$(OBJS)
	$(CC) $(LDFLAGS) -o zcpp$(EXESUFFIX) $(OBJS)


%.o: %.c cpp.h cppdef.h
	$(CC) $(CFLAGS) -c $<

install:
	$(INSTALL) zcpp$(EXESUFFIX) $(PREFIX)/bin

clean:
	$(RM) *.o core *~ zcpp$(EXESUFFIX)
	$(RM) -rf Debug Release
