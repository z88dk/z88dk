;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: ceil.asm,v 1.3 2015-01-19 01:32:56 pauloscustodio Exp $
;


;double ceil(double)  
;Number in FA..
;
;This is implemented as  -(floor(-x))


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    ceil

                EXTERN	fsetup1
                EXTERN	stkequ

.ceil
        call    fsetup1
	defb	ZXFP_NEGATE
	defb	ZXFP_INT
	defb	ZXFP_NEGATE
	defb	ZXFP_END_CALC
        jp      stkequ
