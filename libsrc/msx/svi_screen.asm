;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato, 13/5/2009
;
;	void msx_screen(int mode);
;
;	Change the SVI screen mode; mode in HL (FASTCALL)
;	It should do for SVI what msx_screen does on an MSX
;
;	$Id: svi_screen.asm,v 1.6 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_screen
	PUBLIC	_msx_screen
	EXTERN	msxbios
	
        INCLUDE "svibios.def"
        INCLUDE "svibasic.def"

msx_screen:
_msx_screen:
	ld	hl,SCRMOD
	ld	a,(hl)
	and	a
	jr	z,ok
	dec	a
	ld	(hl),a
ok:
	push	ix
	ld	ix,CHGMOD
	call	msxbios
	pop	ix
	ret
