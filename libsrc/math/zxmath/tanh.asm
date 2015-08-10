;
;
;       ZX Maths Routines
;
;       21/03/03 - Stefano Bodrato
;
;
;       $Id: tanh.asm,v 1.4 2015-08-10 08:52:13 stefano Exp $
;

;double tanh(double)
;	e = exp(x) ;
;	return (e-1.0/e)/(e+1.0/e) ;


IF FORzx
		INCLUDE  "zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "lambdafp.def"
ENDIF

                PUBLIC    tanh

                EXTERN	fsetup1
                EXTERN	stkequ

.tanh

	call	fsetup1

	defb	ZXFP_EXP		; and at the beginning exp (x)
	defb	ZXFP_ST_MEM_0
	
	defb	ZXFP_STK_ONE
	defb	ZXFP_EXCHANGE
	defb	ZXFP_DIVISION		; 1/e 
	
	defb	ZXFP_DUPLICATE
	
	defb	ZXFP_GET_MEM_0
	defb	ZXFP_ADDITION
	
	defb	ZXFP_EXCHANGE
	defb	ZXFP_GET_MEM_0
	
	defb	ZXFP_EXCHANGE
	defb	ZXFP_SUBTRACT
	
	defb	ZXFP_EXCHANGE	; This might be slightly optimized, maybe, but watch out..
				; test it deeply with positive and negative values !
				
IF FORlambda
	defb	ZXFP_DIVISION + 128
ELSE
	defb	ZXFP_DIVISION
	defb	ZXFP_END_CALC
ENDIF
	
	jp	stkequ

