;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_lpt();
;
;	Check if the line printer is ready (1=ready, 0 if not)
;
;	$Id: msx_lpt.asm,v 1.4 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_lpt
	PUBLIC	_msx_lpt
	EXTERN     msxbios
	
        INCLUDE "msxbios.def"

msx_lpt:
_msx_lpt:
	push	ix
	ld	ix,LPTSTT
	call	msxbios
	pop	ix
	ld	hl,0
	ret	z
	inc	l
	ret
