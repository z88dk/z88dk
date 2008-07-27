;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: log10.asm,v 1.1 2008-07-27 21:44:59 aralbrec Exp $
;


;double log10(double)  	-- 1/ln(10)
;Number in FA..


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    log10

                LIB	fsetup1
                LIB	stkequ

.log10
        call    fsetup1
        defb	ZXFP_STK_TEN
	defb	ZXFP_LN
	defb	ZXFP_STK_ONE
	defb	ZXFP_DIVISION
	defb	ZXFP_END_CALC
        jp      stkequ

