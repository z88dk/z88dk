;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato  (Broken release)
;       02/10/23 - Olofsen  (Fix)
;
;       $Id: log10.asm $
;


;double log10(double)  	-- 1/ln(10)
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
                PUBLIC    log10

                EXTERN	fsetup1
                EXTERN	stkequ

.log10
        call    fsetup1
        defb	ZXFP_LN
        defb	ZXFP_STK_TEN
        defb	ZXFP_LN

IF FORlambda
        defb	ZXFP_DIVISION + 128
ELSE
        defb	ZXFP_DIVISION
        defb	ZXFP_END_CALC
ENDIF
        jp      stkequ

