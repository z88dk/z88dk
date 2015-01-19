;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: log.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;


;double log(double)     - natural log
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    log

                EXTERN	fsetup1
                EXTERN	stkequ

.log
        call    fsetup1
	defb	ZXFP_LN
	defb	ZXFP_END_CALC
        jp      stkequ
