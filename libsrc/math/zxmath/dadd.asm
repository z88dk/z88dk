;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: dadd.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    dadd

                EXTERN	fsetup
                EXTERN	stkequ

.dadd
        call    fsetup
	defb	ZXFP_ADDITION
	defb	ZXFP_END_CALC
        jp      stkequ
