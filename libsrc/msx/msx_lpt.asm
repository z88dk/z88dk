;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_lpt();
;
;	Check if the line printer is ready (1=ready, 0 if not)
;
;	$Id: msx_lpt.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msx_lpt
	EXTERN     msxbios
	
        INCLUDE "msxbios.def"

msx_lpt:
	ld	ix,LPTSTT
	call	msxbios
	ld	hl,0
	ret	z
	inc	l
	ret
