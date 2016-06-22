;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: sqrt.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;


;double sqrt(double)  
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

                SECTION  code_fp
                PUBLIC    sqrt

                EXTERN	fsetup1
                EXTERN	stkequ

.sqrt
        call    fsetup1
IF FORlambda
	defb	ZXFP_SQR + 128
ELSE
	defb	ZXFP_SQR
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ

