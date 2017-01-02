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

			INCLUDE	"graphics/grafix.inc"


.clg
._clg
	call $38a9	; FGR
	ld   a,0	; black
;	call $384d	; FCLS
	ld	a,3		; green
	jp  $38da	; FCOLOU
