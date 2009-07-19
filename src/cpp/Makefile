
OBJS=cpp1.o cpp2.o cpp3.o cpp4.o cpp5.o cpp6.o

zcpp$(EXESUFFIX):$(OBJS)
	$(CC) $(LDFLAGS) -o zcpp$(EXESUFFIX) $(OBJS)

cpp1.o:cpp1.c cpp.h cppdef.h
cpp2.o:cpp2.c cpp.h cppdef.h
cpp3.o:cpp3.c cpp.h cppdef.h
cpp4.o:cpp4.c cpp.h cppdef.h
cpp5.o:cpp5.c cpp.h cppdef.h
cpp6.o:cpp6.c cpp.h cppdef.h

install:
	install zcpp$(EXESUFFIX) $(PREFIX)/bin

clean:
	$(RM) *.o core *~ zcpp$(EXESUFFIX)
