;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: dsub.asm,v 1.4 2015-08-10 08:52:12 stefano Exp $
;


IF FORzx
		INCLUDE  "zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "lambdafp.def"
ENDIF

                PUBLIC    dsub

                EXTERN	fsetup
                EXTERN	stkequ

.dsub
        call    fsetup
IF FORlambda
	defb	ZXFP_SUBTRACT + 128
ELSE
	defb	ZXFP_SUBTRACT
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
