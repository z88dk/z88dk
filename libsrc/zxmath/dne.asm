;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: dne.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    dne

                LIB	fsetup

.dne
        call    fsetup
	defb	ZXFP_SUBTRACT
	defb	ZXFP_NOT
	defb	ZXFP_END_CALC

	call	ZXFP_FP_TO_BC
	
        ld	h,b
        ld	l,c
        
	ret
