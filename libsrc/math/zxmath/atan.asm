;
;
;       ZX Maths Routines
;
;       7/12/02 - Stefano Bodrato
;
;       $Id: atan.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;


;double atan(double)
;Number in FA..


IF FORts2068
		INCLUDE  "target/ts2068/def/ts2068fp.def"
ENDIF
IF FORzx
		INCLUDE  "target/zx/def/zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "target/zx81/def/81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "target/lambda/def/lambdafp.def"
ENDIF

                SECTION  code_fp
                PUBLIC    atan

                EXTERN	fsetup1
                EXTERN	stkequ

.atan
        call    fsetup1
IF FORlambda
	defb	ZXFP_ATN + 128
ELSE
	defb	ZXFP_ATN
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
