
OBJS = appmake.o z88.o zxvgs.o zx.o z88shell.o abc80.o zx81.o msx.o mz.o \
	aquarius.o svi.o ace-byt.o ace-tap.o hex.o rex6000.o tixx.o nascom.o \
	cpc.o newbrain.o sms.o
CC = gcc -g


all: appmake 

%.o: %.c appmake.h
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

appmake: $(OBJS)
	${CC} -o appmake $(LDFLAGS) $(OBJS)

install:
	install appmake $(PREFIX)/bin

clean:
	$(RM) appmake $(OBJS) core


