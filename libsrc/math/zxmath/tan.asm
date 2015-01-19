;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: tan.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;


;double tan(double)
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    tan

                EXTERN	fsetup1
                EXTERN	stkequ

.tan
        call    fsetup1
	defb	ZXFP_TAN
	defb	ZXFP_END_CALC
        jp      stkequ

