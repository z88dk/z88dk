;
;       Colour Genie EG2000 graphics routines
;
;       clsgraph ()  -- clear screen
;
;       Stefano Bodrato - 2015
;
;
;       $Id: clsgraph.asm $
;

			SECTION	  code_clib
			PUBLIC    clsgraph
         PUBLIC    _clsgraph

			INCLUDE	"graphics/grafix.inc"


.clsgraph
._clsgraph
	call $38a9	; FGR
	ld	hl,$4800
	ld	bc,$FF0
.clsloop
	ld	 (hl),0
	inc hl
	dec bc
	ld	a,b
	or c
	jr nz,clsloop
	ret
