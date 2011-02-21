
OBJS = appmake.o z88.o zxvgs.o zx.o z88shell.o abc80.o zx81.o msx.o mz.o \
	aquarius.o svi.o sc3000.o ace-tap.o hex.o rex6000.o tixx.o nascom.o \
	cpc.o m5.o newbrain.o sms.o trs80.o c128.o galaksija.o vz.o enterprise.o


all: appmake$(EXESUFFIX)

%.o: %.c appmake.h
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

appmake$(EXESUFFIX): $(OBJS)
	${CC} -o appmake$(EXESUFFIX) $(LDFLAGS) $(OBJS)

install:
	install appmake$(EXESUFFIX) $(PREFIX)/bin

clean:
	$(RM) appmake$(EXESUFFIX) $(OBJS) core


