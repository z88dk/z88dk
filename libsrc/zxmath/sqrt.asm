;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: sqrt.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
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

