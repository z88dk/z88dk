;
;
;       ZX Maths Routines
;
;       Fall 2023 - Stefano Bodrato
;
;       $Id: acosh.asm $
;


;double acosh(double)
;Number in FA..

; ln (x +sqrt(x*x - 1))

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
                PUBLIC    acosh

                EXTERN	fsetup1
                EXTERN	stkequ

.acosh
        call    fsetup1

        defb	ZXFP_DUPLICATE	; save argument

        defb	ZXFP_DUPLICATE	; X^2
        defb	ZXFP_MULTIPLY
        defb	ZXFP_STK_ONE
        defb	ZXFP_SUBTRACT
		defb	ZXFP_SQR
		
		defb	ZXFP_ADDITION

IF FORlambda
	defb	ZXFP_LN + 128
ELSE
	defb	ZXFP_LN
	defb	ZXFP_END_CALC
ENDIF

        jp      stkequ



