;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: floor.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;


;double floor(double)  
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    floor

                EXTERN	fsetup1
                EXTERN	stkequ

.floor
        call    fsetup1
	defb	ZXFP_INT
	defb	ZXFP_END_CALC
        jp      stkequ
