;
;       Clear Graphics Screen
;
;       MSX version by Stefano Bodrato, December 2007
;
;	$Id: clg.asm,v 1.9 2015-01-19 01:32:49 pauloscustodio Exp $
;

        PUBLIC    clg
        EXTERN	msxbios
        EXTERN	msx_color

        INCLUDE	"graphics/grafix.inc"


IF FORmsx
        INCLUDE "msxbios.def"
        INCLUDE "msxbasic.def"
ELSE
        INCLUDE "svibios.def"
        INCLUDE "svibasic.def"
ENDIF


.clg
	ld	ix,CHGMOD
IF FORmsx
	ld	a,2		; set graphics mode
ELSE
	ld	a,1
ENDIF
	ld	(SCRMOD),a
	call	msxbios

	ld	a,15
	ld	(BDRCLR),a	;border
	ld	ix,CHGCLR
	call	msxbios

	ld bc,6144

	ld a,$1F

	ld hl,8192

	ld ix,FILVRM
	jp msxbios
