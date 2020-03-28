
include ../../../../Make.config

CFILES = $(wildcard *.c)
OFILES = $(CFILES:.c=.o)

all: $(OFILES)

%.o: %.c
	$(ZCC) +test -DOZ -D__OZ__ $(CFLAGS) $^

clean:
	$(RM) *.o* zcc_opt.def
