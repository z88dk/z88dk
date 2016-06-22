;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: sin.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;


;double cos(double)
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

                SECTION  code_fp
                PUBLIC    sin

                EXTERN	fsetup1
                EXTERN	stkequ

.sin
        call    fsetup1
IF FORlambda
	defb	ZXFP_SIN + 128
ELSE
	defb	ZXFP_SIN
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ

