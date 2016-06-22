;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: dsub.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
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

                SECTION  code_fp
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
