;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: dlt.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;


IF FORzx
		INCLUDE  "zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "lambdafp.def"
ENDIF

                SECTION  code_fp
                PUBLIC    dlt

                EXTERN	fsetup
                EXTERN	f_yesno

.dlt
        call    fsetup
	defb	ZXFP_SUBTRACT
IF FORlambda
	defb	ZXFP_LESS_0 + 128
ELSE
	defb	ZXFP_LESS_0
	defb	ZXFP_END_CALC
ENDIF
	
	jp	f_yesno
