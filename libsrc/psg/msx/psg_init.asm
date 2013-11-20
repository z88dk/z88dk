;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_initpsg();
;
;	Init the PSG (reset sound etc..)
;
;
;	$Id: psg_init.asm,v 1.1 2013-11-20 09:05:43 stefano Exp $
;

	XLIB	psg_init
	LIB     msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

psg_init:
	ld	ix,GICINI
	jp	msxbios
