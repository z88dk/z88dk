;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	void msx_clearkey();
;
;	Clears the keyboard buffer
;
;	$Id: msx_clearkey.asm,v 1.4 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msx_clearkey
	EXTERN     msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

msx_clearkey:
	ld	ix,KILBUF
	jp	msxbios
