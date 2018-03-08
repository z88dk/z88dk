;
;       Otrona Attachè graphics routines
;		console driven video HW access
;
;       Stefano Bodrato 2018
;
;
;
;	$Id: w_undrawto.asm $
;


			INCLUDE	"graphics/grafix.inc"

        SECTION code_clib
                PUBLIC    undrawto
                PUBLIC    _undrawto
				
                EXTERN    drawto
				EXTERN	setres

.undrawto
._undrawto
				CALL	setres
				
				jp  drawto

