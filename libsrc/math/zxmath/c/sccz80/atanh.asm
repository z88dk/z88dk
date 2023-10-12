;
;
;       ZX Maths Routines
;
;       Fall 2023 - Stefano Bodrato
;
;
;       $Id: atanh.asm $
;

;double atanh(double)
; (log (1+x) - log (1-x)) / 2

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
                PUBLIC    atanh

                EXTERN	fsetup1
                EXTERN	stkequ

.atanh

        call    fsetup1

        defb	ZXFP_DUPLICATE	; save argument

        defb	ZXFP_STK_ONE	; 1+x
        defb	ZXFP_ADDITION
		defb	ZXFP_LN

		defb	ZXFP_EXCHANGE

        defb	ZXFP_STK_ONE	; 1-x
		defb	ZXFP_EXCHANGE
        defb	ZXFP_SUBTRACT
		defb	ZXFP_LN

        defb	ZXFP_SUBTRACT

		defb	ZXFP_STK_ONE  ; /2
		defb	ZXFP_STK_ONE
        defb	ZXFP_ADDITION

IF FORlambda
	defb	ZXFP_DIVISION + 128
ELSE
	defb	ZXFP_DIVISION
	defb	ZXFP_END_CALC
ENDIF

        jp      stkequ
