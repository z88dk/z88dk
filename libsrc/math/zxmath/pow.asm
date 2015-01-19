;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: pow.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;
;double pow(double x,double y)  
;y is in the FA
;x is on the stack +8 (+2=y) 
;


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    pow

                EXTERN	fsetupf
                EXTERN	stkequ

.pow
        call    fsetupf
	defb	ZXFP_TO_POWER
	defb	ZXFP_END_CALC
        jp      stkequ
