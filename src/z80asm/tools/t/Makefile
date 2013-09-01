OBJS = main.o init.o mod1.o mod2.o mod3.o
INIT = mod1.h mod2.h mod3.h
MAKE_INIT = ../make_init.pl

CFLAGS 	+= -I$(GLIB_ROOT)/include/glib-2.0 -I$(GLIB_ROOT)/lib/glib-2.0/include
LDFLAGS += -L$(GLIB_ROOT)/lib -lglib-2.0

main.exe : $(OBJS)
	$(CC) $(CFLAGS) -o main.exe $(OBJS) $(LDFLAGS)

init.c init.h : $(INIT) $(MAKE_INIT)
	perl $(MAKE_INIT) $(INIT)
	
depend:
	makedepend -Y $(OBJS:.o=.c)

# DO NOT DELETE

main.o: init.h
init.o: mod1.h mod2.h mod3.h
mod1.o: mod1.h
mod2.o: mod2.h
mod3.o: mod3.h
