;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	void msx_noblank();
;
;	Enable screen
;
;	$Id: msx_noblank.asm,v 1.4 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msx_noblank
	EXTERN	msxbios
	
        INCLUDE "msxbios.def"

msx_noblank:

	ld	ix,ENASCR
	jp	msxbios
