;
;	MSX specific routines
;	by Stefano Bodrato, 30/11/2007
;
;	int msx_text();
;
;	Switch to text mode
;
;	$Id: msx_text.asm,v 1.5 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msx_text
	EXTERN	msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF

msx_text:
	ld	ix,TOTEXT
	jp	msxbios
