;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: pow.asm $
;
;double pow(double x,double y)  
;y is in the FA
;x is on the stack +8 (+2=y) 
;


IF FORts2068
		INCLUDE  "target/ts2068/def/ts2068fp.def"
ENDIF
IF FORzx
		INCLUDE  "target/zx/def/zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "target/zx81/def/81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "target/lambda/def/lambdafp.def"
ENDIF

                SECTION  code_fp
                PUBLIC    pow

                EXTERN	fsetupf
                EXTERN	stkequ

.pow
        call    fsetupf

	; deal with negative exponents and force them to positive
	defb	ZXFP_EXCHANGE
	defb	ZXFP_ABS
	defb	ZXFP_EXCHANGE

IF FORlambda
	defb	ZXFP_TO_POWER + 128
ELSE
	defb	ZXFP_TO_POWER
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
