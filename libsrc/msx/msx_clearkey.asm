;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	void msx_clearkey();
;
;	Clears the keyboard buffer
;
;	$Id: msx_clearkey.asm,v 1.5 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msx_clearkey
	PUBLIC	_msx_clearkey
	EXTERN     msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

msx_clearkey:
_msx_clearkey:
	push	ix
	ld	ix,KILBUF
	call	msxbios
	pop	ix
	ret
