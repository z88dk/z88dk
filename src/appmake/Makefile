INSTALL ?= install

INCLUDES += -I..

OBJS = appmake.o z88.o zxvgs.o zx.o z88shell.o abc80.o zx81.o msx.o mtx.o mz.o nec.o p2000.o px.o \
	aquarius.o c7420.o rom.o sorcerer.o sos.o svi.o sc3000.o ace-tap.o hex.o lynx.o rex6000.o tixx.o nascom.o \
	cpc.o cpm.o m5.o mc.o newbrain.o newext.o sms.o trs80.o c128.o galaksija.o vz.o enterprise.o x07.o residos.o \
	inject.o vg5k.o z1013.o extract.o z9001.o kc.o glue.o zxn.o zx-util.o x1.o multi8.o spc1000.o mz2500.o \
	d88.o fp1100.o cpmdisk.o einstein.o


all: appmake$(EXESUFFIX)

CFLAGS += -g

%.o: %.c appmake.h zx-util.h d88.h cpmdisk.h
	$(CC) $(CFLAGS) $(INCLUDES) -c $<

appmake$(EXESUFFIX): $(OBJS)
	$(CC) -o appmake$(EXESUFFIX) $(LDFLAGS) $(OBJS)

install:
	$(INSTALL) appmake$(EXESUFFIX) $(PREFIX)/bin/$(EXEC_PREFIX)appmake$(EXESUFFIX)

clean:
	$(RM) appmake$(EXESUFFIX) $(OBJS) core
	$(RM) -rf Debug Release



