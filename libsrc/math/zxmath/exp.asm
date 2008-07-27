;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: exp.asm,v 1.1 2008-07-27 21:44:58 aralbrec Exp $
;


;double exp(double)
;Number in FA..


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    exp

                LIB	fsetup1
                LIB	stkequ

.exp
        call    fsetup1
	defb	ZXFP_EXP
	defb	ZXFP_END_CALC
        jp      stkequ

