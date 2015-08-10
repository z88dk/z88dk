;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: log.asm,v 1.4 2015-08-10 08:52:13 stefano Exp $
;


;double log(double)     - natural log
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

                PUBLIC    log

                EXTERN	fsetup1
                EXTERN	stkequ

.log
        call    fsetup1
IF FORlambda
	defb	ZXFP_LN + 128
ELSE
	defb	ZXFP_LN
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
