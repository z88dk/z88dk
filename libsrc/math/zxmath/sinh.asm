;
;
;       ZX Maths Routines
;
;       21/03/03 - Stefano Bodrato
;
;       $Id: sinh.asm,v 1.1 2008-07-27 21:44:59 aralbrec Exp $
;

;double sinh(double)
;	e = exp(x) ;
;	return ((e-1.0/e)/2) ;

IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    sinh

                LIB	fsetup1
                LIB	stkequ

.sinh
        call    fsetup1

	defb	ZXFP_EXP		; and at the beginning exp (x)

	defb	ZXFP_DUPLICATE
	defb	ZXFP_STK_ONE
	defb	ZXFP_EXCHANGE
	defb	ZXFP_DIVISION		; 1/e 

	defb	ZXFP_SUBTRACT

	defb	ZXFP_STK_ONE		; STK_TWO  :o)
	defb	ZXFP_STK_ONE
	defb	ZXFP_ADDITION

	defb	ZXFP_DIVISION
	
	defb	ZXFP_END_CALC
        jp      stkequ

