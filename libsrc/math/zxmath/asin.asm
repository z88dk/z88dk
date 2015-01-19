;
;
;       ZX Maths Routines
;
;       7/12/02 - Stefano Bodrato
;
;       $Id: asin.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;


;double asin(double)
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    asin

                EXTERN	fsetup1
                EXTERN	stkequ

.asin
        call    fsetup1
	defb	ZXFP_ASN
	defb	ZXFP_END_CALC
        jp      stkequ
