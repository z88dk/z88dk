;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: tan.asm,v 1.4 2015-08-10 08:52:13 stefano Exp $
;


;double tan(double)
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

                PUBLIC    tan

                EXTERN	fsetup1
                EXTERN	stkequ

.tan
        call    fsetup1
IF FORlambda
	defb	ZXFP_TAN + 128
ELSE
	defb	ZXFP_TAN
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ

