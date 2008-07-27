;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: sqrt.asm,v 1.1 2008-07-27 21:44:59 aralbrec Exp $
;


;double sqrt(double)  
;Number in FA..


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    sqrt

                LIB	fsetup1
                LIB	stkequ

.sqrt
        call    fsetup1
	defb	ZXFP_SQR
	defb	ZXFP_END_CALC
        jp      stkequ

