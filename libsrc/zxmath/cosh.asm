;
;
;       ZX Maths Routines
;
;       21/03/03 - Stefano Bodrato
;
;       $Id: cosh.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;
;
;double cosh(double)
;Number in FA..
;	e = exp(x) ;
;	return 0.5*(e+1.0/e) ;
;


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    cosh

                LIB	fsetup1
                LIB	stkequ

.cosh
        call    fsetup1

	defb	ZXFP_EXP		; and at the beginning exp (x)
	defb	ZXFP_DUPLICATE
	defb	ZXFP_STK_ONE
	defb	ZXFP_EXCHANGE
	defb	ZXFP_DIVISION		; 1/e 
	defb	ZXFP_ADDITION
	defb	ZXFP_STK_HALF
	defb	ZXFP_MULTIPLY
	
	defb	ZXFP_END_CALC
        jp      stkequ
