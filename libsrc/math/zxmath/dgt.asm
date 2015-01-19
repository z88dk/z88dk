;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: dgt.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    dgt

                EXTERN	fsetup
                EXTERN	f_yesno

.dgt
        call    fsetup
	defb	ZXFP_SUBTRACT
	defb	ZXFP_GREATER_0
	defb	ZXFP_END_CALC
	
	jp	f_yesno