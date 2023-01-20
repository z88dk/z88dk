;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: sqrt.asm $
;


;double sqrt(double)
;Number in FA..


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
                PUBLIC    sqrt

                EXTERN	fsetup1
                EXTERN	stkequ

.sqrt
        call    fsetup1

; In C the square root of a negative number forces ZERO.
; SQR( (ABS(N)+N) / 2 ) does the trick
	defb	ZXFP_DUPLICATE
	defb	ZXFP_ABS
	defb	ZXFP_ADDITION
	defb	ZXFP_STK_HALF
	defb	ZXFP_MULTIPLY

IF FORlambda
	defb	ZXFP_SQR + 128
ELSE
	defb	ZXFP_SQR
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ

