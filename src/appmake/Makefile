
OBJS = appmake.o
CC = gcc


all: appmake 

appmake:	$(OBJS)
	${CC} -o appmake $(LDFLAGS) $(OBJS)

install:
	install appmake $(PREFIX)/bin

clean:
	$(RM) appmake appmake.o core


#Dependencies

appmake.o: appmake.c 
