;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: dmul.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    dmul

                LIB	fsetup
                LIB	stkequ

.dmul
        call    fsetup
	defb	ZXFP_MULTIPLY
	defb	ZXFP_END_CALC
        jp      stkequ
