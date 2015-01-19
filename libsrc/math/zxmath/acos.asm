;
;
;       ZX Maths Routines
;
;       6/12/02 - Stefano Bodrato
;
;       $Id: acos.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;


;double acos(double)
;Number in FA..

IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    acos

                EXTERN	fsetup1
                EXTERN	stkequ

.acos
        call    fsetup1
	defb	ZXFP_ACS
	defb	ZXFP_END_CALC
        jp      stkequ



