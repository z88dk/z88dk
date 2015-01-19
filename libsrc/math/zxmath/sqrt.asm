;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: sqrt.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;


;double sqrt(double)  
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    sqrt

                EXTERN	fsetup1
                EXTERN	stkequ

.sqrt
        call    fsetup1
	defb	ZXFP_SQR
	defb	ZXFP_END_CALC
        jp      stkequ

