;
;
;       ZX Maths Routines
;
;       9/12/02 - Stefano Bodrato
;
;       $Id: dne.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;


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
                PUBLIC    dne

                EXTERN	fsetup
                EXTERN	f_yesno

.dne
        call    fsetup
	defb	ZXFP_SUBTRACT
	defb	ZXFP_NOT
IF FORlambda
	defb	ZXFP_NOT + 128
ELSE
	defb	ZXFP_NOT
	defb	ZXFP_END_CALC
ENDIF
	
	jp	f_yesno
