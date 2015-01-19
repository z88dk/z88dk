;
;
;       ZX Maths Routines
;
;       10/12/02 - Stefano Bodrato
;
;       $Id: sin.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;


;double cos(double)
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    sin

                EXTERN	fsetup1
                EXTERN	stkequ

.sin
        call    fsetup1
	defb	ZXFP_SIN
	defb	ZXFP_END_CALC
        jp      stkequ

