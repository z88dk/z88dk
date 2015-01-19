;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	int msx_color(int foreground, int background, int border );
;
;	Change the MSX color attributes
;
;	$Id: msx_color.asm,v 1.5 2015-01-19 01:32:57 pauloscustodio Exp $
;

	PUBLIC	msx_color
	EXTERN	msxbios
	
IF FORmsx
        INCLUDE "msxbios.def"
        INCLUDE "msxbasic.def"
ELSE
        INCLUDE "svibios.def"
        INCLUDE "svibasic.def"
ENDIF


msx_color:
	ld	ix,0
	add	ix,sp
	ld	a,(ix+2)	;border
	ld	(BDRCLR),a
	ld	a,(ix+4)	;background
	ld	(BAKCLR),a
	ld	a,(ix+6)	;foreground
	ld	(FORCLR),a
	ld	a,(0FCAFh)	;SCRMOD
	ld	ix,CHGCLR
	jp	msxbios
