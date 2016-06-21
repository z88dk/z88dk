;
;       Clear Graphics Screen
;
;       MSX version by Stefano Bodrato, December 2007
;
;	$Id: clg.asm,v 1.10 2016-06-21 20:16:35 dom Exp $
;

	SECTION	code_clib
        PUBLIC    clg
        PUBLIC    _clg
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
._clg
	push	ix	;save callers
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
	call	msxbios
	pop	ix	;restore callers
	ret
