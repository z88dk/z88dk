;
;
;       ZX Maths Routines
;
;       7/12/02 - Stefano Bodrato
;
;       $Id: amax.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;


;double amax (double x,double y)  
;
;returns the larger of x and y


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                XLIB    amax

                LIB	fsetup
                LIB	stkequ

.amax
        call    fsetup
	defb	ZXFP_NO_GRTR		; Not greater
	defb	ZXFP_JUMP_TRUE		; Don't exchange
	defb	2			; [offset to go over the next byte]
	defb	ZXFP_EXCHANGE
	defb	ZXFP_STK_FETCH		; take away the smaller no from stack
	defb	ZXFP_END_CALC

        jp      stkequ
