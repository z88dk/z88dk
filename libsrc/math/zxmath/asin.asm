;
;
;       ZX Maths Routines
;
;       7/12/02 - Stefano Bodrato
;
;       $Id: asin.asm,v 1.4 2015-08-10 08:52:12 stefano Exp $
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
