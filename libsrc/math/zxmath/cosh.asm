;
;
;       ZX Maths Routines
;
;       21/03/03 - Stefano Bodrato
;
;       $Id: cosh.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;
;
;double cosh(double)
;Number in FA..
;	e = exp(x) ;
;	return 0.5*(e+1.0/e) ;
;


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    cosh

                EXTERN	fsetup1
                EXTERN	stkequ

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
