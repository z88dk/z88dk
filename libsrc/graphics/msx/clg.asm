;
;       Clear Graphics Screen
;
;       MSX version by Stefano Bodrato, December 2007
;
;	$Id: clg.asm $
;

	SECTION	code_clib
        PUBLIC    clg
        PUBLIC    _clg
        EXTERN	msxbios

	EXTERN     swapgfxbk
        EXTERN	__graphics_end

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
	call	swapgfxbk
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
	
	jp __graphics_end
