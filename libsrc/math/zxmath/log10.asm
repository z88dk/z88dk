;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: log10.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;


;double log10(double)  	-- 1/ln(10)
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "lambdafp.def"
ENDIF

                SECTION  code_fp
                PUBLIC    log10

                EXTERN	fsetup1
                EXTERN	stkequ

.log10
        call    fsetup1
        defb	ZXFP_STK_TEN
	defb	ZXFP_LN
	defb	ZXFP_STK_ONE
IF FORlambda
	defb	ZXFP_DIVISION + 128
ELSE
	defb	ZXFP_DIVISION
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ

