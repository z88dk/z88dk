;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	void msx_noblank();
;
;	Enable screen
;
;	$Id: msx_noblank.asm,v 1.5 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_noblank
	PUBLIC	_msx_noblank
	EXTERN	msxbios
	
        INCLUDE "msxbios.def"

msx_noblank:
_msx_noblank:
	push	ix
	ld	ix,ENASCR
	call	msxbios
	pop	ix
	ret
