INSTALL ?= install

OBJS = appmake.o z88.o zxvgs.o zx.o z88shell.o abc80.o zx81.o msx.o mtx.o mz.o nec.o p2000.o px.o \
	aquarius.o c7420.o rom.o sorcerer.o sos.o svi.o sc3000.o ace-tap.o hex.o lynx.o rex6000.o tixx.o nascom.o \
	cpc.o m5.o mc.o newbrain.o newext.o sms.o trs80.o c128.o galaksija.o vz.o enterprise.o x07.o residos.o \
	inject.o vg5k.o z1013.o extract.o z9001.o kc.o


all: appmake$(EXESUFFIX)

%.o: %.c appmake.h
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

appmake$(EXESUFFIX): $(OBJS)
	$(CC) -o appmake$(EXESUFFIX) $(LDFLAGS) $(OBJS)

install:
	$(INSTALL) appmake$(EXESUFFIX) $(PREFIX)/bin

clean:
	$(RM) appmake$(EXESUFFIX) $(OBJS) core
	$(RM) -rf Debug Release



