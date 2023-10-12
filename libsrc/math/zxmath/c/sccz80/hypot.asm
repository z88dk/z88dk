;
;
;       ZX Maths Routines
;
;       Fall 2023 - Stefano Bodrato
;
;       $Id: hypot.asm $
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
                PUBLIC    hypot

                EXTERN	fsetupf
                EXTERN	stkequ

.hypot
        call    fsetupf

	defb	ZXFP_DUPLICATE         ; x^2
	defb	ZXFP_MULTIPLY

	defb	ZXFP_EXCHANGE

	defb	ZXFP_DUPLICATE         ; y^2
	defb	ZXFP_MULTIPLY
	
	; hypotenuse: sqrt(x*x+y*y)

	defb	ZXFP_ADDITION

IF FORlambda
	defb	ZXFP_SQR + 128
ELSE
	defb	ZXFP_SQR
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
