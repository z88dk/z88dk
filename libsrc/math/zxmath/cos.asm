;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: cos.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;


;double cos(double)
;Number in FA..


IF FORzx
		INCLUDE  "arch/zx/def/zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "arch/zx81/def/81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "arch/lambda/def/lambdafp.def"
ENDIF

                SECTION  code_fp
                PUBLIC    cos

                EXTERN	fsetup1
                EXTERN	stkequ

.cos
        call    fsetup1
IF FORlambda
	defb	ZXFP_COS + 128
ELSE
	defb	ZXFP_COS
	defb	ZXFP_END_CALC
ENDIF
        jp      stkequ
