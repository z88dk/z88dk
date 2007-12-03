;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	void msx_screen(int mode);
;
;	Change the MSX screen mode; mode in HL (FASTCALL)
;
;	$Id: msx_screen.asm,v 1.1 2007-12-03 07:29:39 stefano Exp $
;

	XLIB	msx_screen
	LIB	msxbios
	
msx_screen:
	ld	a,l
	ld	ix,$5F	; CHGMOD
	jp	msxbios
