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
	jp $38a9	; FGR
