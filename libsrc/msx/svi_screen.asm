;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato, 13/5/2009
;
;	void msx_screen(int mode);
;
;	Change the SVI screen mode; mode in HL (FASTCALL)
;	It should do for SVI what msx_screen does on an MSX
;
;	$Id: svi_screen.asm,v 1.4 2009-06-22 21:44:17 dom Exp $
;

	XLIB	msx_screen
	LIB	msxbios
	
        INCLUDE "svibios.def"
        INCLUDE "svibasic.def"

msx_screen:
	ld	hl,SCRMOD
	ld	a,(hl)
	and	a
	jr	z,ok
	dec	a
	ld	(hl),a
ok:
	ld	ix,CHGMOD
	jp	msxbios
