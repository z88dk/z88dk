;
;
;       ZX Maths Routines
;
;       Fall 2023 - Stefano Bodrato
;
;       $Id: log2.asm $
;


;double log2(double)
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
                PUBLIC    log2

                EXTERN	fsetup1
                EXTERN	stkequ

.log2
        call    fsetup1

        defb	ZXFP_STK_ONE	; stack 2
        defb	ZXFP_STK_ONE
        defb	ZXFP_ADDITION

		defb	ZXFP_LN			; ln(2)
		
		defb	ZXFP_EXCHANGE
		defb	ZXFP_LN
		defb	ZXFP_EXCHANGE
		
IF FORlambda
	defb	ZXFP_DIVISION + 128
ELSE
	defb	ZXFP_DIVISION
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
