;
; 	ANSI Video handling for the MSX
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - Oct. 2017
;
;
;	$Id: f_ansi_cls.asm $
;

	SECTION	code_clib
        PUBLIC    ansi_cls
        PUBLIC    _ansi_cls
        EXTERN	msxbios
        EXTERN	__tms9918_attribute

        INCLUDE	"graphics/grafix.inc"


IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
        INCLUDE "target/msx/def/msxbasic.def"
ELSE
        INCLUDE "target/svi/def/svibios.def"
        INCLUDE "target/svi/def/svibasic.def"
ENDIF

EXTERN	clg

.ansi_cls
._ansi_cls
;jp clg

	push	ix	;save callers
	ld	ix,CHGMOD
IF FORmsx
	ld	a,2		; set graphics mode
ELSE
	ld	a,1
ENDIF
	ld	(SCRMOD),a
	call	msxbios

	ld a,(__tms9918_attribute)
	and $0F
	ld	(BDRCLR),a	;border
	ld	ix,CHGCLR
	call	msxbios

	ld bc,6144

	ld a,(__tms9918_attribute)

	ld hl,8192

	ld ix,FILVRM
	call	msxbios
	pop	ix	;restore callers
	ret



