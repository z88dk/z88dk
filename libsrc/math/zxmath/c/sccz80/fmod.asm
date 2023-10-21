;
;
;       ZX Maths Routines
;
;       10/10/2023 - Stefano Bodrato
;
;       $Id: fmod.asm $
;


;double fmod(n,m)
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
                PUBLIC    fmod

                EXTERN	fsetupf
                EXTERN	stkequ

.fmod
        call    fsetupf

        defb	ZXFP_N_MOD_M
IF FORlambda
        defb	ZXFP_DELETE + 128
ELSE
        defb	ZXFP_DELETE
        defb	ZXFP_END_CALC
ENDIF

        jp      stkequ

