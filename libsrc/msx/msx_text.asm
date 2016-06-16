;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	int msx_text();
;
;	Switch to text mode
;
;	$Id: msx_text.asm,v 1.6 2016-06-16 19:30:25 dom Exp $
;
        SECTION code_clib
	PUBLIC	msx_text
	PUBLIC	_msx_text
	EXTERN	msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

msx_text:
_msx_text:
	push	ix
	ld	ix,TOTEXT
	call	msxbios
	pop	ix
	ret
