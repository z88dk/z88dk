
OBJS=cpp1.o cpp2.o cpp3.o cpp4.o cpp5.o cpp6.o

zcpp:$(OBJS)
	$(CC) $(CCOPT) -o ../../bin/zcpp $(OBJS)

cpp1.o:cpp1.c cpp.h cppdef.h
	$(CC) $(CCOPT) -c -o cpp1.o cpp1.c

cpp2.o:cpp2.c cpp.h cppdef.h
	$(CC) $(CCOPT) -c -o cpp2.o cpp2.c

cpp3.o:cpp3.c cpp.h cppdef.h
	$(CC) $(CCOPT) -c -o cpp3.o cpp3.c

cpp4.o:cpp4.c cpp.h cppdef.h
	$(CC) $(CCOPT) -c -o cpp4.o cpp4.c

cpp5.o:cpp5.c cpp.h cppdef.h
	$(CC) $(CCOPT) -c -o cpp5.o cpp5.c

cpp6.o:cpp6.c cpp.h cppdef.h
	$(CC) $(CCOPT) -c -o cpp6.o cpp6.c

install:
	install ../../bin/zcpp $(PREFIX)/bin

clean:
	rm -f *.o core *~
