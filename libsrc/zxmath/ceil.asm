;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: ceil.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


;double ceil(double)  
;Number in FA..
;
;This is implemented as  -(floor(-x))


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    ceil

                LIB	fsetup1
                LIB	stkequ

.ceil
        call    fsetup1
	defb	ZXFP_NEGATE
	defb	ZXFP_INT
	defb	ZXFP_NEGATE
	defb	ZXFP_END_CALC
        jp      stkequ
