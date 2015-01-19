;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: exp.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;


;double exp(double)
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    exp

                EXTERN	fsetup1
                EXTERN	stkequ

.exp
        call    fsetup1
	defb	ZXFP_EXP
	defb	ZXFP_END_CALC
        jp      stkequ

