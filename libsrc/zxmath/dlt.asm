;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: dlt.asm,v 1.2 2006-05-23 19:45:32 stefano Exp $
;


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    dlt

                LIB	fsetup
                LIB	f_yesno

.dlt
        call    fsetup
	defb	ZXFP_SUBTRACT
	defb	ZXFP_LESS_0
	defb	ZXFP_END_CALC
	
	jp	f_yesno