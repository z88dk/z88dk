;
;
;       ZX Maths Routines
;
;       11/03/08 - Stefano Bodrato
;
;       $Id: pi.asm,v 1.1 2008-07-27 21:44:59 aralbrec Exp $
;


;double pi()
;Number in FA..


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    pi

                LIB	stkequ

.pi
	rst	ZXFP_BEGIN_CALC
	defb	ZXFP_STK_PI_D_2
	defb	ZXFP_DUPLICATE
	defb	ZXFP_ADDITION	; PI/2 + PI/2
	defb	ZXFP_END_CALC
        jp      stkequ

