;
;
;       ZX Maths Routines
;
;       7/12/02 - Stefano Bodrato
;
;       $Id: amin.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


;double amin (double x,double y)  
;
;returns the smaller of x and y


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    amin

                LIB	fsetup
                LIB	stkequ

.amin
	call    fsetup
	defb	ZXFP_NO_LESS		; Not lesser
	defb	ZXFP_JUMP_TRUE		; Don't exchange
	defb	2			; [offset to go over the next byte]
	defb	ZXFP_EXCHANGE
	defb	ZXFP_STK_FETCH		; take away the smaller no from stack
	defb	ZXFP_END_CALC

        jp      stkequ
