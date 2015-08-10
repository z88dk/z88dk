;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: pow.asm,v 1.4 2015-08-10 08:52:13 stefano Exp $
;
;double pow(double x,double y)  
;y is in the FA
;x is on the stack +8 (+2=y) 
;


IF FORzx
		INCLUDE  "zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "lambdafp.def"
ENDIF

                PUBLIC    pow

                EXTERN	fsetupf
                EXTERN	stkequ

.pow
        call    fsetupf
IF FORlambda
	defb	ZXFP_TO_POWER + 128
ELSE
	defb	ZXFP_TO_POWER
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
