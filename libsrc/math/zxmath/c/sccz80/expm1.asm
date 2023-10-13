;
;
;       ZX Maths Routines
;
;       Fall 2023 - Stefano Bodrato
;
;       $Id: expm1.asm $
;


;double expm1(double)
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
                PUBLIC    expm1

                EXTERN	fsetup1
                EXTERN	stkequ

.expm1
        call    fsetup1

	defb	ZXFP_EXP
	defb	ZXFP_STK_ONE

IF FORlambda
	defb	ZXFP_SUBTRACT + 128
ELSE
	defb	ZXFP_SUBTRACT
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ

