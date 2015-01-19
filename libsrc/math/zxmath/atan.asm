;
;
;       ZX Maths Routines
;
;       7/12/02 - Stefano Bodrato
;
;       $Id: atan.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;


;double atan(double)
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    atan

                EXTERN	fsetup1
                EXTERN	stkequ

.atan
        call    fsetup1
	defb	ZXFP_ATN
	defb	ZXFP_END_CALC
        jp      stkequ
