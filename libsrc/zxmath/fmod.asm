;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: fmod.asm,v 1.1 2003-03-24 09:17:40 stefano Exp $
;


;double fmod(n,m)
;Number in FA..


IF FORzx
		INCLUDE  "#zxfp.def"
ELSE
		INCLUDE  "#81fp.def"
ENDIF

                XLIB    fmod

                LIB	fsetup
                LIB	stkequ

.fmod
        call    fsetup
	defb	ZXFP_N_MOD_M
	defb	ZXFP_END_CALC
        jp      stkequ

