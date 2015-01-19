;
;
;       ZX Maths Routines
;
;       21/03/03 - Stefano Bodrato
;
;
;       $Id: tanh.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;

;double tanh(double)
;	e = exp(x) ;
;	return (e-1.0/e)/(e+1.0/e) ;


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
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
	defb	ZXFP_DIVISION
	
	defb	ZXFP_END_CALC
	
	jp	stkequ

