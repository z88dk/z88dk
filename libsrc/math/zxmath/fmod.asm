;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: fmod.asm,v 1.4 2015-08-10 08:52:12 stefano Exp $
;


;double fmod(n,m)
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

                PUBLIC    fmod

                EXTERN	fsetup
                EXTERN	stkequ

.fmod
        call    fsetup
	defb	ZXFP_N_MOD_M
	defb	ZXFP_END_CALC
        jp      stkequ

