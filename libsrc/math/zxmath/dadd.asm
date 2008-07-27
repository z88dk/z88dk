;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: dadd.asm,v 1.1 2008-07-27 21:44:58 aralbrec Exp $
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
