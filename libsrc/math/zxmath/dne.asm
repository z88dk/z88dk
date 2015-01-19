;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: dne.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    dne

                EXTERN	fsetup
                EXTERN	f_yesno

.dne
        call    fsetup
	defb	ZXFP_SUBTRACT
	defb	ZXFP_NOT
	defb	ZXFP_NOT
	defb	ZXFP_END_CALC
	
	jp	f_yesno