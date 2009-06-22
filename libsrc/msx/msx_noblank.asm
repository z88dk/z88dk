;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	void msx_noblank();
;
;	Enable screen
;
;	$Id: msx_noblank.asm,v 1.3 2009-06-22 21:44:17 dom Exp $
;

	XLIB	msx_noblank
	LIB	msxbios
	
        INCLUDE "msxbios.def"

msx_noblank:

	ld	ix,ENASCR
	jp	msxbios
