;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: ddiv.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    ddiv

                EXTERN	fsetup
                EXTERN	stkequ

.ddiv
        call    fsetup
	defb	ZXFP_DIVISION
	defb	ZXFP_END_CALC
        jp      stkequ
