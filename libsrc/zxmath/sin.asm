;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: sin.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


;double cos(double)
;Number in FA..


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    sin

                LIB	fsetup1
                LIB	stkequ

.sin
        call    fsetup1
	defb	ZXFP_SIN
	defb	ZXFP_END_CALC
        jp      stkequ

