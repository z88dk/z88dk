;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: fabs.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;


;double fabs(double)
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    fabs

                EXTERN	fsetup1
                EXTERN	stkequ

.fabs
        call    fsetup1
	defb	ZXFP_ABS
	defb	ZXFP_END_CALC
        jp      stkequ
