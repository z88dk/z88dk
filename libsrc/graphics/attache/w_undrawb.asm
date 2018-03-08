;
;       Otrona Attachè graphics routines
;		console driven video HW access
;
;       Stefano Bodrato 2018
;
;
;
;	$Id: w_undrawb.asm $
;


			INCLUDE	"graphics/grafix.inc"

        SECTION code_clib
                PUBLIC    undrawb
                PUBLIC    _undrawb
				
                EXTERN    drawb
				EXTERN	setres

.undrawb
._undrawb

				CALL	setres
				
				jp  drawb

