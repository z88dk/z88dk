;
;
;       ZX Maths Routines
;
;       7/12/02 - Stefano Bodrato
;
;       $Id: atan.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


;double atan(double)
;Number in FA..


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    atan

                LIB	fsetup1
                LIB	stkequ

.atan
        call    fsetup1
	defb	ZXFP_ATN
	defb	ZXFP_END_CALC
        jp      stkequ
