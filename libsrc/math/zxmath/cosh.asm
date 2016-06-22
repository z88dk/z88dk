;
;
;       ZX Maths Routines
;
;       21/03/03 - Stefano Bodrato
;
;       $Id: cosh.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;
;
;double cosh(double)
;Number in FA..
;	e = exp(x) ;
;	return 0.5*(e+1.0/e) ;
;


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
IF FORlambda
	defb	ZXFP_MULTIPLY + 128
ELSE
	defb	ZXFP_MULTIPLY
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
