;
;
;       ZX Maths Routines
;
;       7/12/02 - Stefano Bodrato
;
;       $Id: asin.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;


;double asin(double)
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                XLIB    asin

                LIB	fsetup1
                LIB	stkequ

.asin
        call    fsetup1
	defb	ZXFP_ASN
	defb	ZXFP_END_CALC
        jp      stkequ
