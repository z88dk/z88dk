OBJS = main.o \
	init.o init_obj.o \
	init_obj_mod1.o \
	mod1.o mod2.o mod3.o
INIT = mod1.h mod2.h mod3.h
MAKE_INIT  = ../make_init.pl
MAKE_TEMPL = $(wildcard ../*.c ../*.h)

CFLAGS 	+= -I$(GLIB_ROOT)/include/glib-2.0 -I$(GLIB_ROOT)/lib/glib-2.0/include
LDFLAGS += -L$(GLIB_ROOT)/lib -lglib-2.0

main.exe : $(OBJS)
	$(CC) $(CFLAGS) -o main.exe $(OBJS) $(LDFLAGS)

init.c init.h : $(INIT) $(MAKE_INIT) $(MAKE_TEMPL) Makefile
	perl $(MAKE_INIT) $(INIT)
	$(MAKE) depend

clean:
	$(RM) *.o *.exe *.bak
	$(RM) -rf Debug Release

depend:
	makedepend -Y $(OBJS:.o=.c) 2>nul

# DO NOT DELETE

main.o: init.h memalloc.h mod1.h mod2.h mod3.h
init.o: memalloc.h init.h mod1.h mod2.h mod3.h
init_obj.o: memalloc.h init.h mod1.h mod2.h mod3.h
init_obj_mod1.o: memalloc.h init.h mod1.h mod2.h mod3.h
mod1.o: mod1.h
mod2.o: mod2.h
mod3.o: mod3.h
