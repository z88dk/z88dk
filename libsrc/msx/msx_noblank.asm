;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	void msx_noblank();
;
;	Enable screen
;
;	$Id: msx_noblank.asm,v 1.2 2007-12-07 11:28:59 stefano Exp $
;

	XLIB	msx_noblank
	LIB	msxbios
	
        INCLUDE "#msxbios.def"

msx_noblank:

	ld	ix,ENASCR
	jp	msxbios
