;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: tan.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


;double tan(double)
;Number in FA..


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    tan

                LIB	fsetup1
                LIB	stkequ

.tan
        call    fsetup1
	defb	ZXFP_TAN
	defb	ZXFP_END_CALC
        jp      stkequ

