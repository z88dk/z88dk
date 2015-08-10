;
;
;       ZX Maths Routines
;
;       21/03/03 - Stefano Bodrato
;
;       $Id: sinh.asm,v 1.4 2015-08-10 08:52:13 stefano Exp $
;

;double sinh(double)
;	e = exp(x) ;
;	return ((e-1.0/e)/2) ;

IF FORzx
		INCLUDE  "zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "lambdafp.def"
ENDIF

                PUBLIC    sinh

                EXTERN	fsetup1
                EXTERN	stkequ

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

IF FORlambda
	defb	ZXFP_DIVISION + 128
ELSE
	defb	ZXFP_DIVISION
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ

