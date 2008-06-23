#
# Wahey, a messed up makefile for building libraries!
#
# $Id: Makefile,v 1.1 2008-06-23 17:37:54 stefano Exp $
#

include ../Make.config

CIAFILES = \
	getkeyscia.c \
	getjoyscia.c \
	gettimeracia.c \
	gettimerbcia.c \
	gettodcia.c \
	setintctrlcia.c \
	settimeracia.c \
	settimerbcia.c \
	settodcia.c \
	timervalcia.c \
	todcharcia.c \
	todstrcia.c \
	is64kvdc.c \
	printstrvdc.c \
	set64kvdc.c \
	set80x50textvdc.c \
	setbitmapvdc.c \
	setbitmapintvdc.c \
	attrsonvdc.c \
	attrsoffvdc.c \
	printbmivdc.c \
	printbmvdc.c \
	memtobufvdc.c \
	buftomemvdc.c \
	circlepointsvdc.c \
	circleivdc.c \
	clrattrvdc.c \
	clrbitmapvdc.c \
	clrscrvdc.c \
	copymemvdc.c \
	copydspvdc.c \
	setcursorvdc.c \
	ellipsevdc.c \
	ellipseivdc.c \
	fillattrvdc.c \
	filldspvdc.c \
	fillmemvdc.c \
	linevdc.c \
	lineivdc.c \
	mapvdc.c \
	initpcx.c \
	donepcx.c \
	decodelinepcx.c \
	decodefilepcx.c \
	decodelineintpcx.c \
	decodefileintpcx.c \
	savevdc.c \
	restorevdc.c \
	setcharvdc.c \
	setdsppagevdc.c \
	scrollupvdc.c \
	scrolldownvdc.c \
	winvdc.c \
	clrwinattrvdc.c \
	clrwinvdc.c \
	attacksid.c \
	releasesid.c \
	clearsid.c \
	volumesid.c \
	envelopesid.c \
	freqsid.c \
	pulsewavesid.c \
	getmousesid.c \
	getpotssid.c

CIAOBJECTS = $(CIAFILES:.c=.o)

AFILES  = $(CIAFILES:.c=.asm)

all:    $(CIAOBJECTS)

.c.o:
	zcc +test $(CFLAGS) $*.c

clean:
	$(RM) *.o* *.sym *.map zcc_opt.def *.i $(AFILES)
