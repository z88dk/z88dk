;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: dadd.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                XLIB    dadd

                LIB	fsetup
                LIB	stkequ

.dadd
        call    fsetup
	defb	ZXFP_ADDITION
	defb	ZXFP_END_CALC
        jp      stkequ
