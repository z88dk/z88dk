;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: floor.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


;double floor(double)  
;Number in FA..


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    floor

                LIB	fsetup1
                LIB	stkequ

.floor
        call    fsetup1
	defb	ZXFP_INT
	defb	ZXFP_END_CALC
        jp      stkequ
