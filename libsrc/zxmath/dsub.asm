;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: dsub.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    dsub

                LIB	fsetup
                LIB	stkequ

.dsub
        call    fsetup
	defb	ZXFP_SUBTRACT
	defb	ZXFP_END_CALC
        jp      stkequ
