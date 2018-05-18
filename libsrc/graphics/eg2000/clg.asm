;
;       Colour Genie EG2000 graphics routines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2015
;
;
;       $Id: clg.asm $
;

			SECTION	code_clib
			PUBLIC    clg
         PUBLIC    _clg

			INCLUDE	"graphics/grafix.inc"


.clg
._clg
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
	
;	call $38a9	; FGR
;	xor a	; black
;	call $3852	; FCLS
;	ret
