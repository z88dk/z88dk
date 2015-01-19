;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: dmul.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    dmul

                EXTERN	fsetup
                EXTERN	stkequ

.dmul
        call    fsetup
	defb	ZXFP_MULTIPLY
	defb	ZXFP_END_CALC
        jp      stkequ
