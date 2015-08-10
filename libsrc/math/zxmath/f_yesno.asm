;
;
;       ZX Maths Routines
;
;       23/05/06 - Stefano Bodrato
;
;       $Id: f_yesno.asm,v 1.4 2015-08-10 08:52:12 stefano Exp $
;


; Support for boolean - save some byte

IF FORzx
		INCLUDE  "zxfp.def"
ENDIF
IF FORzx81
		INCLUDE  "81fp.def"
ENDIF
IF FORlambda
		INCLUDE  "lambdafp.def"
ENDIF

        PUBLIC    f_yesno


.f_yesno
	call	ZXFP_FP_TO_BC

IF FORzx
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
