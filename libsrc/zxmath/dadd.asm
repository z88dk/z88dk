;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: dadd.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    dadd

                LIB	fsetup
                LIB	stkequ

.dadd
        call    fsetup
	defb	ZXFP_ADDITION
	defb	ZXFP_END_CALC
        jp      stkequ
