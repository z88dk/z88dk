;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: dge.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    dge

                LIB	fsetup

.dge
        call    fsetup
	defb	ZXFP_SUBTRACT
	defb	ZXFP_LESS_0
	defb	ZXFP_NOT
	defb	ZXFP_END_CALC

	call	ZXFP_FP_TO_BC
	
        ld	h,b
        ld	l,c
        
        ret
