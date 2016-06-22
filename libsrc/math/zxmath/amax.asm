;
;
;       ZX Maths Routines
;
;       7/12/02 - Stefano Bodrato
;
;       $Id: amax.asm,v 1.7 2016-06-22 19:59:18 dom Exp $
;


;double amax (double x,double y)  
;
;returns the larger of x and y


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
                PUBLIC    amax

                EXTERN	fsetup
                EXTERN	stkequ

.amax
        call    fsetup
	defb	ZXFP_NO_GRTR		; Not greater
	defb	ZXFP_JUMP_TRUE		; Don't exchange
	defb	2			; [offset to go over the next byte]
	defb	ZXFP_EXCHANGE
	defb	ZXFP_END_CALC
	call	ZXFP_STK_FETCH		; take away the smaller no from stack

        jp      stkequ
