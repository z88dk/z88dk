;
;
;       ZX Maths Routines
;
;       7/12/02 - Stefano Bodrato
;
;       $Id: asin.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;


;double asin(double)
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
                PUBLIC    asin

                EXTERN	fsetup1
                EXTERN	stkequ

.asin
        call    fsetup1
IF FORlambda
	defb	ZXFP_ASN + 128
ELSE
	defb	ZXFP_ASN
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
