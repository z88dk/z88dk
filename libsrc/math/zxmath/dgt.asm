;
;
;       ZX Maths Routines
;
;       8/12/02 - Stefano Bodrato
;
;       $Id: dgt.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
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
                PUBLIC    dgt

                EXTERN	fsetup
                EXTERN	f_yesno

.dgt
        call    fsetup
	defb	ZXFP_SUBTRACT
IF FORlambda
	defb	ZXFP_GREATER_0 + 128
ELSE
	defb	ZXFP_GREATER_0
	defb	ZXFP_END_CALC
ENDIF
	
	jp	f_yesno
