;
;       Otrona Attachè graphics routines
;		console driven video HW access
;
;       Stefano Bodrato 2018
;
;
;
;	$Id: w_undrawr.asm $
;


			INCLUDE	"graphics/grafix.inc"

        SECTION code_clib
                PUBLIC    undrawr
                PUBLIC    _undrawr
				
                EXTERN    drawr
				EXTERN	setres

.undrawr
._undrawr

				CALL	setres
				
				jp  drawr

