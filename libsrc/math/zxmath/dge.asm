;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: dge.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    dge

                EXTERN	fsetup
                EXTERN	f_yesno

.dge
        call    fsetup
	defb	ZXFP_SUBTRACT
	defb	ZXFP_LESS_0
	defb	ZXFP_NOT
	defb	ZXFP_END_CALC
	
	jp	f_yesno