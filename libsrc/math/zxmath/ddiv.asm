;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: ddiv.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
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
                PUBLIC    ddiv

                EXTERN	fsetup
                EXTERN	stkequ

.ddiv
        call    fsetup
IF FORlambda
	defb	ZXFP_DIVISION + 128
ELSE
	defb	ZXFP_DIVISION
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
