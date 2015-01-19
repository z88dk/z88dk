;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: log10.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;


;double log10(double)  	-- 1/ln(10)
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    log10

                EXTERN	fsetup1
                EXTERN	stkequ

.log10
        call    fsetup1
        defb	ZXFP_STK_TEN
	defb	ZXFP_LN
	defb	ZXFP_STK_ONE
	defb	ZXFP_DIVISION
	defb	ZXFP_END_CALC
        jp      stkequ

