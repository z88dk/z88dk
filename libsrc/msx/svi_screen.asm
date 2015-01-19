;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato, 13/5/2009
;
;	void msx_screen(int mode);
;
;	Change the SVI screen mode; mode in HL (FASTCALL)
;	It should do for SVI what msx_screen does on an MSX
;
;	$Id: svi_screen.asm,v 1.5 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msx_screen
	EXTERN	msxbios
	
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
