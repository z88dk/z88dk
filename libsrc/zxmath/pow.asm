;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: pow.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;
;double pow(double x,double y)  
;y is in the FA
;x is on the stack +8 (+2=y) 
;


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    pow

                LIB	fsetupf
                LIB	stkequ

.pow
        call    fsetupf
	defb	ZXFP_TO_POWER
	defb	ZXFP_END_CALC
        jp      stkequ
