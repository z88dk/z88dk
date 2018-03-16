;
;       Otrona Attachè graphics routines
;		console driven video HW access
;
;       Stefano Bodrato 2018
;
;
;
;	$Id: w_undraw.asm $
;


			INCLUDE	"graphics/grafix.inc"

        SECTION code_clib
                PUBLIC    undraw
                PUBLIC    _undraw
				
                EXTERN    draw
				EXTERN	setres

.undraw
._undraw
				CALL	setres
				
				jp  draw

