
INSTALL ?= install
CFILES = mem.c nhash.c cpp.c lexer.c assert.c macro.c eval.c 
OBJS = $(CFILES:.c=.o)
DEPENDS := $(OBJS:.o=.d)



CFLAGS += -MMD -DSTAND_ALONE -DUCPP_CONFIG

ucpp$(EXESUFFIX):$(OBJS)
	$(CC) $(LDFLAGS) -o ucpp$(EXESUFFIX) $(OBJS)


%.o: %.c 
	$(CC) $(CFLAGS) -c $<

install:
	$(INSTALL) ucpp$(EXESUFFIX) $(PREFIX)/bin/$(EXEC_PREFIX)ucpp$(EXESUFFIX)

clean:
	$(RM) *.o core *~ ucpp$(EXESUFFIX) *.d
	$(RM) -rf Debug Release

-include $(DEPENDS)
