;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: fabs.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


;double fabs(double)
;Number in FA..


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    fabs

                LIB	fsetup1
                LIB	stkequ

.fabs
        call    fsetup1
	defb	ZXFP_ABS
	defb	ZXFP_END_CALC
        jp      stkequ
