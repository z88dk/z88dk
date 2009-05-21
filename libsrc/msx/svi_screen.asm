;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato, 13/5/2009
;
;	void msx_screen(int mode);
;
;	Change the SVI screen mode; mode in HL (FASTCALL)
;	It should do for SVI what msx_screen does on an MSX
;
;	$Id: svi_screen.asm,v 1.1 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	msx_screen
	LIB	msxbios
	
        INCLUDE "#svibios.def"

msx_screen:
	ld	ix,CHGMOD
	jp	msxbios
