;
;
;       ZX Maths Routines
;
;       6/12/02 - Stefano Bodrato
;
;       $Id: acos.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


;double acos(double)
;Number in FA..

IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    acos

                LIB	fsetup1
                LIB	stkequ

.acos
        call    fsetup1
	defb	ZXFP_ACS
	defb	ZXFP_END_CALC
        jp      stkequ



