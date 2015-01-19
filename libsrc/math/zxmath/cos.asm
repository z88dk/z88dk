;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: cos.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;


;double cos(double)
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    cos

                EXTERN	fsetup1
                EXTERN	stkequ

.cos
        call    fsetup1
	defb	ZXFP_COS
	defb	ZXFP_END_CALC
        jp      stkequ
