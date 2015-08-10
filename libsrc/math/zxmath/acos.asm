;
;
;       ZX Maths Routines
;
;       6/12/02 - Stefano Bodrato
;
;       $Id: acos.asm,v 1.4 2015-08-10 08:52:12 stefano Exp $
;


;double acos(double)
;Number in FA..

IF FORzx
		INCLUDE  "zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "lambdafp.def"
ENDIF

                PUBLIC    acos

                EXTERN	fsetup1
                EXTERN	stkequ

.acos
        call    fsetup1
IF FORlambda
	defb	ZXFP_ACS + 128
ELSE
	defb	ZXFP_ACS
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ



