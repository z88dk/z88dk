;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: log1p.asm $
;


;double log1p(double)     - natural log of value + 1
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
                PUBLIC    log1p

                EXTERN	fsetup1
                EXTERN	stkequ

.log1p
        call    fsetup1

	defb	ZXFP_STK_ONE
	defb	ZXFP_ADDITION

IF FORlambda
	defb	ZXFP_LN + 128
ELSE
	defb	ZXFP_LN
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
