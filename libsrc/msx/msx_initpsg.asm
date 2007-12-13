;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_initpsg();
;
;	Init the PSG (reset sound etc..)
;
;
;	$Id: msx_initpsg.asm,v 1.1 2007-12-13 11:28:42 stefano Exp $
;

	XLIB	msx_initpsg
	LIB     msxbios
	
        INCLUDE "#msxbios.def"

msx_initpsg:
	ld	ix,GICINI
	jp	msxbios
