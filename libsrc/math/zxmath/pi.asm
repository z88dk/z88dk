;
;
;       ZX Maths Routines
;
;       11/03/08 - Stefano Bodrato
;
;       $Id: pi.asm,v 1.4 2015-08-10 08:52:13 stefano Exp $
;


;double pi()
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "lambdafp.def"
ENDIF

                PUBLIC    pi

                EXTERN	stkequ

.pi
	rst	ZXFP_BEGIN_CALC
	defb	ZXFP_STK_PI_D_2
	defb	ZXFP_DUPLICATE
IF FORlambda
	defb	ZXFP_ADDITION + 128	; PI/2 + PI/2
ELSE
	defb	ZXFP_ADDITION	; PI/2 + PI/2
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ

