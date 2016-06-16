;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	void msx_blank();
;
;	Disable screen
;
;	$Id: msx_blank.asm,v 1.5 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_blank
	PUBLIC	_msx_blank
	EXTERN	msxbios
	
        INCLUDE "msxbios.def"

msx_blank:
_msx_blank:
	push	ix		;save callers
	ld	ix,DISSCR
	call	msxbios
	pop	ix
	ret
