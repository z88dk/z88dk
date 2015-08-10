;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: fabs.asm,v 1.4 2015-08-10 08:52:12 stefano Exp $
;


;double fabs(double)
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

                PUBLIC    fabs

                EXTERN	fsetup1
                EXTERN	stkequ

.fabs
        call    fsetup1
IF FORlambda
	defb	ZXFP_ABS + 128
ELSE
	defb	ZXFP_ABS
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
