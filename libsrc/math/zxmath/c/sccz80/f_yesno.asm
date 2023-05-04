;
;
;       ZX Maths Routines
;
;       23/05/06 - Stefano Bodrato
;
;       $Id: f_yesno.asm,v 1.5 2016-06-22 19:59:18 dom Exp $
;


; Support for boolean - save some byte

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
        PUBLIC    f_yesno


.f_yesno
	call	ZXFP_FP_TO_BC

IF (FORzx | FORts2068)
        ld	h,b
        ld	l,c
ELSE
        ld	h,c
        ld	l,b
ENDIF

        xor	a
        or	l
        ret	z       ;sets nc

        scf
	ret
