;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_initpsg();
;
;	Init the PSG (reset sound etc..)
;
;
;	$Id: msx_initpsg.asm,v 1.3 2009-06-22 21:44:17 dom Exp $
;

	XLIB	msx_initpsg
	LIB     msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

msx_initpsg:
	ld	ix,GICINI
	jp	msxbios
