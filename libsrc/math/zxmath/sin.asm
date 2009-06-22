;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: sin.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;


;double cos(double)
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                XLIB    sin

                LIB	fsetup1
                LIB	stkequ

.sin
        call    fsetup1
	defb	ZXFP_SIN
	defb	ZXFP_END_CALC
        jp      stkequ

