;
;       Colour Genie EG2000 graphics routines
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - 2015
;
;
;       $Id: clg.asm,v 1.3 2017-01-02 22:57:58 aralbrec Exp $
;

			SECTION	code_clib
			PUBLIC    clg
         PUBLIC    _clg

	EXTERN	base_graphics
	
			INCLUDE	"graphics/grafix.inc"


.clg
._clg
	call $38a9	; FGR
	xor a	; black
	call $3852	; FCLS
	;ld	a,3		; green
	;call  $38da	; FCOLOU
	;call $384d	; FCLS
	ret
