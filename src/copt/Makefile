
OBJS = copt.o
CC = gcc


all: copt 

copt:	$(OBJS)
	$(CC) -o copt $(LDFLAGS) $(OBJS)

install:
	install copt $(PREFIX)/bin

clean:
	$(RM) copt copt.o core


#Dependencies

copt.o: copt.c 
