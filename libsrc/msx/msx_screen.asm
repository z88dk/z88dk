;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	void msx_screen(int mode);
;
;	Change the MSX screen mode; mode in HL (FASTCALL)
;
;	$Id: msx_screen.asm,v 1.2 2007-12-07 11:28:59 stefano Exp $
;

	XLIB	msx_screen
	LIB	msxbios
	
        INCLUDE "#msxbios.def"

msx_screen:
	ld	a,l
	ld	ix,CHGMOD
	jp	msxbios
