;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: cos.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


;double cos(double)
;Number in FA..


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    cos

                LIB	fsetup1
                LIB	stkequ

.cos
        call    fsetup1
	defb	ZXFP_COS
	defb	ZXFP_END_CALC
        jp      stkequ
