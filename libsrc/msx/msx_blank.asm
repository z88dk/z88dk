;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	void msx_blank();
;
;	Disable screen
;
;	$Id: msx_blank.asm,v 1.4 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msx_blank
	EXTERN	msxbios
	
        INCLUDE "msxbios.def"

msx_blank:

	ld	ix,DISSCR
	jp	msxbios
