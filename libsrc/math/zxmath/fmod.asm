;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: fmod.asm,v 1.3 2015-01-19 01:32:57 pauloscustodio Exp $
;


;double fmod(n,m)
;Number in FA..


IF FORzx
		INCLUDE  "zxfp.def"
ELSE
		INCLUDE  "81fp.def"
ENDIF

                PUBLIC    fmod

                EXTERN	fsetup
                EXTERN	stkequ

.fmod
        call    fsetup
	defb	ZXFP_N_MOD_M
	defb	ZXFP_END_CALC
        jp      stkequ

