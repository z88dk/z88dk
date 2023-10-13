;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: exp2.asm $
;


;double exp2(double)
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
                PUBLIC    exp2

                EXTERN	fsetup1
                EXTERN	stkequ

.exp2
        call    fsetup1

	defb	ZXFP_STK_ONE
	defb	ZXFP_STK_ONE
	defb	ZXFP_ADDITION
	defb	ZXFP_EXCHANGE

IF FORlambda
	defb	ZXFP_TO_POWER + 128
ELSE
	defb	ZXFP_TO_POWER
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ

