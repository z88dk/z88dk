;
;
;       ZX Maths Routines
;
;       6/12/02 - Stefano Bodrato
;
;       $Id: acos.asm,v 1.2 2009-06-22 21:44:17 dom Exp $
;


;double acos(double)
;Number in FA..

IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                XLIB    acos

                LIB	fsetup1
                LIB	stkequ

.acos
        call    fsetup1
	defb	ZXFP_ACS
	defb	ZXFP_END_CALC
        jp      stkequ



