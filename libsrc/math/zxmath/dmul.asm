;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: dmul.asm,v 1.4 2015-08-10 08:52:12 stefano Exp $
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

                PUBLIC    dmul

                EXTERN	fsetup
                EXTERN	stkequ

.dmul
        call    fsetup
IF FORlambda
	defb	ZXFP_MULTIPLY + 128
ELSE
	defb	ZXFP_MULTIPLY
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
